"""
Message Broker for Agent Communication in the Multi-Agent Text-to-SQL system.
Handles routing, delivery, and coordination of messages between agents.
"""

import asyncio
from typing import Dict, List, Optional, Set, Callable, Any
from collections import defaultdict, deque
from dataclasses import dataclass, field
from enum import Enum
import uuid
from datetime import datetime, timedelta

from ..agents.base_agent import Message, MessageType, BaseAgent
from ..core.logging import logger
from ..core.config import settings


class BrokerStatus(Enum):
    """Status of the message broker."""
    STOPPED = "stopped"
    STARTING = "starting"
    RUNNING = "running"
    STOPPING = "stopping"
    ERROR = "error"


@dataclass
class RouteRule:
    """Rule for routing messages between agents."""
    pattern: str
    source: Optional[str] = None
    destination: Optional[str] = None
    message_type: Optional[MessageType] = None
    priority: int = 0
    active: bool = True


@dataclass
class MessageQueue:
    """Message queue for an agent."""
    agent_name: str
    messages: deque = field(default_factory=deque)
    max_size: int = 1000
    processing: bool = False
    
    def add_message(self, message: Message) -> bool:
        """Add a message to the queue."""
        if len(self.messages) >= self.max_size:
            logger.warning(f"Queue for {self.agent_name} is full, dropping oldest message")
            self.messages.popleft()
        
        self.messages.append(message)
        return True
    
    def get_message(self) -> Optional[Message]:
        """Get the next message from the queue."""
        try:
            return self.messages.popleft()
        except IndexError:
            return None
    
    def size(self) -> int:
        """Get the current queue size."""
        return len(self.messages)


class MessageBroker:
    """
    Central message broker for the Multi-Agent system.
    
    Responsible for:
    - Routing messages between agents
    - Managing message queues
    - Handling delivery confirmations
    - Monitoring message flow
    - Load balancing
    """
    
    def __init__(self):
        self.status = BrokerStatus.STOPPED
        self.agents: Dict[str, BaseAgent] = {}
        self.queues: Dict[str, MessageQueue] = {}
        self.routes: List[RouteRule] = []
        self.message_handlers: Dict[str, List[Callable]] = defaultdict(list)
        self.metrics = {
            "messages_routed": 0,
            "messages_delivered": 0,
            "messages_failed": 0,
            "average_delivery_time": 0.0,
            "active_agents": 0,
            "queue_sizes": {}
        }
        self.delivery_confirmations: Dict[str, datetime] = {}
        self._running = False
        self._tasks: Set[asyncio.Task] = set()
    
    async def start(self) -> None:
        """Start the message broker."""
        if self.status == BrokerStatus.RUNNING:
            return
        
        self.status = BrokerStatus.STARTING
        self._running = True
        
        # Start background tasks
        routing_task = asyncio.create_task(self._routing_loop())
        monitoring_task = asyncio.create_task(self._monitoring_loop())
        cleanup_task = asyncio.create_task(self._cleanup_loop())
        
        self._tasks.update([routing_task, monitoring_task, cleanup_task])
        
        self.status = BrokerStatus.RUNNING
        logger.info("Message broker started successfully")
    
    async def stop(self) -> None:
        """Stop the message broker."""
        self.status = BrokerStatus.STOPPING
        self._running = False
        
        # Cancel all tasks
        for task in self._tasks:
            task.cancel()
        
        # Wait for tasks to complete
        await asyncio.gather(*self._tasks, return_exceptions=True)
        self._tasks.clear()
        
        self.status = BrokerStatus.STOPPED
        logger.info("Message broker stopped")
    
    def register_agent(self, agent: BaseAgent) -> None:
        """
        Register an agent with the broker.
        
        Args:
            agent: The agent to register
        """
        self.agents[agent.name] = agent
        self.queues[agent.name] = MessageQueue(agent.name)
        self.metrics["active_agents"] = len(self.agents)
        
        logger.info(f"Agent {agent.name} registered with broker")
    
    def unregister_agent(self, agent_name: str) -> None:
        """
        Unregister an agent from the broker.
        
        Args:
            agent_name: Name of the agent to unregister
        """
        if agent_name in self.agents:
            del self.agents[agent_name]
        if agent_name in self.queues:
            del self.queues[agent_name]
        
        self.metrics["active_agents"] = len(self.agents)
        logger.info(f"Agent {agent_name} unregistered from broker")
    
    def add_route(self, rule: RouteRule) -> None:
        """
        Add a routing rule.
        
        Args:
            rule: The routing rule to add
        """
        self.routes.append(rule)
        self.routes.sort(key=lambda r: r.priority, reverse=True)
        logger.info(f"Added routing rule: {rule.pattern}")
    
    async def send_message(self, message: Message) -> bool:
        """
        Send a message through the broker.
        
        Args:
            message: The message to send
            
        Returns:
            bool: True if message was successfully queued, False otherwise
        """
        try:
            # Check if destination agent exists
            if message.receiver not in self.agents:
                logger.error(f"Destination agent {message.receiver} not found")
                self.metrics["messages_failed"] += 1
                return False
            
            # Apply routing rules
            routed_message = await self._apply_routing_rules(message)
            
            # Add to destination queue
            queue = self.queues[routed_message.receiver]
            success = queue.add_message(routed_message)
            
            if success:
                self.metrics["messages_routed"] += 1
                logger.debug(f"Message {message.id} queued for {message.receiver}")
            else:
                self.metrics["messages_failed"] += 1
                logger.error(f"Failed to queue message {message.id} for {message.receiver}")
            
            return success
            
        except Exception as e:
            logger.error(f"Error sending message {message.id}: {str(e)}")
            self.metrics["messages_failed"] += 1
            return False
    
    async def _apply_routing_rules(self, message: Message) -> Message:
        """Apply routing rules to a message."""
        for rule in self.routes:
            if not rule.active:
                continue
            
            # Check if rule matches
            if self._rule_matches(rule, message):
                # Apply rule transformations
                if rule.destination:
                    message.receiver = rule.destination
                break
        
        return message
    
    def _rule_matches(self, rule: RouteRule, message: Message) -> bool:
        """Check if a routing rule matches a message."""
        if rule.source and rule.source != message.sender:
            return False
        
        if rule.message_type and rule.message_type != message.message_type:
            return False
        
        # Pattern matching could be more sophisticated
        if rule.pattern and rule.pattern not in str(message.content):
            return False
        
        return True
    
    async def _routing_loop(self) -> None:
        """Main routing loop that processes queued messages."""
        while self._running:
            try:
                for agent_name, queue in self.queues.items():
                    if queue.processing or queue.size() == 0:
                        continue
                    
                    # Get the agent
                    agent = self.agents.get(agent_name)
                    if not agent:
                        continue
                    
                    # Get next message
                    message = queue.get_message()
                    if not message:
                        continue
                    
                    # Mark queue as processing
                    queue.processing = True
                    
                    # Deliver message to agent
                    asyncio.create_task(
                        self._deliver_message(agent, message, queue)
                    )
                
                await asyncio.sleep(0.01)  # Small delay to prevent CPU spinning
                
            except Exception as e:
                logger.error(f"Error in routing loop: {str(e)}")
                await asyncio.sleep(1)
    
    async def _deliver_message(self, agent: BaseAgent, message: Message, queue: MessageQueue) -> None:
        """
        Deliver a message to an agent.
        
        Args:
            agent: The destination agent
            message: The message to deliver
            queue: The agent's message queue
        """
        try:
            start_time = datetime.now()
            
            # Add message to agent's internal queue
            await agent.message_queue.put(message)
            
            # Record delivery
            delivery_time = (datetime.now() - start_time).total_seconds()
            self.metrics["messages_delivered"] += 1
            self.metrics["average_delivery_time"] = (
                (self.metrics["average_delivery_time"] * (self.metrics["messages_delivered"] - 1) + delivery_time)
                / self.metrics["messages_delivered"]
            )
            
            self.delivery_confirmations[message.id] = datetime.now()
            
            logger.debug(f"Message {message.id} delivered to {agent.name} in {delivery_time:.3f}s")
            
        except Exception as e:
            logger.error(f"Failed to deliver message {message.id} to {agent.name}: {str(e)}")
            self.metrics["messages_failed"] += 1
        
        finally:
            queue.processing = False
    
    async def _monitoring_loop(self) -> None:
        """Background loop for monitoring and metrics collection."""
        while self._running:
            try:
                # Update queue size metrics
                self.metrics["queue_sizes"] = {
                    name: queue.size() for name, queue in self.queues.items()
                }
                
                # Log metrics periodically
                if self.metrics["messages_routed"] > 0 and self.metrics["messages_routed"] % 100 == 0:
                    logger.info(f"Broker metrics: {self.metrics}")
                
                await asyncio.sleep(10)  # Update every 10 seconds
                
            except Exception as e:
                logger.error(f"Error in monitoring loop: {str(e)}")
                await asyncio.sleep(10)
    
    async def _cleanup_loop(self) -> None:
        """Background loop for cleanup tasks."""
        while self._running:
            try:
                # Clean up old delivery confirmations
                cutoff_time = datetime.now() - timedelta(hours=1)
                self.delivery_confirmations = {
                    msg_id: timestamp for msg_id, timestamp in self.delivery_confirmations.items()
                    if timestamp > cutoff_time
                }
                
                await asyncio.sleep(300)  # Cleanup every 5 minutes
                
            except Exception as e:
                logger.error(f"Error in cleanup loop: {str(e)}")
                await asyncio.sleep(300)
    
    def get_status(self) -> Dict[str, Any]:
        """Get broker status and metrics."""
        return {
            "status": self.status.value,
            "agents": list(self.agents.keys()),
            "routes": len(self.routes),
            "metrics": self.metrics,
            "queue_sizes": {name: queue.size() for name, queue in self.queues.items()}
        }


# Global message broker instance
message_broker = MessageBroker() 