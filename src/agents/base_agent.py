"""
Base Agent class for the Multi-Agent Text-to-SQL system.
All specific agents will inherit from this base class.
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, List
from dataclasses import dataclass
from enum import Enum
import asyncio
import uuid
from datetime import datetime

from ..core.logging import get_agent_logger
from ..core.config import settings


class MessageType(Enum):
    """Types of messages exchanged between agents."""
    REQUEST = "request"
    RESPONSE = "response"
    ERROR = "error"
    INFO = "info"
    COORDINATION = "coordination"


class AgentStatus(Enum):
    """Status of an agent."""
    IDLE = "idle"
    PROCESSING = "processing"
    ERROR = "error"
    BUSY = "busy"


@dataclass
class Message:
    """Message format for agent communication."""
    id: str
    sender: str
    receiver: str
    message_type: MessageType
    content: Dict[str, Any]
    timestamp: datetime
    correlation_id: Optional[str] = None


@dataclass
class AgentCapability:
    """Represents a capability of an agent."""
    name: str
    description: str
    input_types: List[str]
    output_types: List[str]


class BaseAgent(ABC):
    """
    Base class for all agents in the Multi-Agent system.
    
    This class provides common functionality for:
    - Message handling and communication
    - Logging and monitoring
    - Error handling and retries
    - State management
    """
    
    def __init__(self, name: str, description: str = ""):
        self.name = name
        self.description = description
        self.id = str(uuid.uuid4())
        self.status = AgentStatus.IDLE
        self.logger = get_agent_logger(self.name)
        self.message_queue: asyncio.Queue = asyncio.Queue()
        self.capabilities: List[AgentCapability] = []
        self.metrics = {
            "messages_processed": 0,
            "errors_count": 0,
            "average_processing_time": 0.0,
            "last_activity": None
        }
        
        self.logger.info(f"Agent {self.name} initialized with ID: {self.id}")
    
    @abstractmethod
    async def process_message(self, message: Message) -> Message:
        """
        Process an incoming message and return a response.
        
        Args:
            message: The incoming message to process
            
        Returns:
            Message: The response message
        """
        pass
    
    @abstractmethod
    def get_capabilities(self) -> List[AgentCapability]:
        """
        Return the list of capabilities this agent provides.
        
        Returns:
            List of AgentCapability objects
        """
        pass
    
    async def send_message(self, receiver: str, message_type: MessageType, 
                          content: Dict[str, Any], correlation_id: Optional[str] = None) -> str:
        """
        Send a message to another agent.
        
        Args:
            receiver: Name of the receiving agent
            message_type: Type of the message
            content: Message content
            correlation_id: Optional correlation ID for tracking
            
        Returns:
            str: Message ID
        """
        message = Message(
            id=str(uuid.uuid4()),
            sender=self.name,
            receiver=receiver,
            message_type=message_type,
            content=content,
            timestamp=datetime.now(),
            correlation_id=correlation_id
        )
        
        self.logger.info(f"Sending message {message.id} to {receiver}")
        # TODO: Implement actual message routing through message broker
        return message.id
    
    async def receive_message(self) -> Optional[Message]:
        """
        Receive a message from the queue.
        
        Returns:
            Message or None if queue is empty
        """
        try:
            message = await asyncio.wait_for(self.message_queue.get(), timeout=1.0)
            return message
        except asyncio.TimeoutError:
            return None
    
    async def handle_message(self, message: Message) -> None:
        """
        Handle an incoming message with error handling and metrics.
        
        Args:
            message: The message to handle
        """
        start_time = datetime.now()
        self.status = AgentStatus.PROCESSING
        
        try:
            self.logger.info(f"Processing message {message.id} from {message.sender}")
            
            response = await self.process_message(message)
            
            if response:
                await self.send_message(
                    receiver=message.sender,
                    message_type=MessageType.RESPONSE,
                    content=response.content,
                    correlation_id=message.correlation_id
                )
            
            # Update metrics
            processing_time = (datetime.now() - start_time).total_seconds()
            self.metrics["messages_processed"] += 1
            self.metrics["average_processing_time"] = (
                (self.metrics["average_processing_time"] * (self.metrics["messages_processed"] - 1) + processing_time) 
                / self.metrics["messages_processed"]
            )
            self.metrics["last_activity"] = datetime.now()
            
            self.logger.info(f"Successfully processed message {message.id} in {processing_time:.2f}s")
            
        except Exception as e:
            self.metrics["errors_count"] += 1
            self.status = AgentStatus.ERROR
            self.logger.error(f"Error processing message {message.id}: {str(e)}")
            
            # Send error response
            error_response = Message(
                id=str(uuid.uuid4()),
                sender=self.name,
                receiver=message.sender,
                message_type=MessageType.ERROR,
                content={
                    "error": str(e),
                    "original_message_id": message.id
                },
                timestamp=datetime.now(),
                correlation_id=message.correlation_id
            )
            
            await self.send_message(
                receiver=message.sender,
                message_type=MessageType.ERROR,
                content=error_response.content,
                correlation_id=message.correlation_id
            )
        
        finally:
            self.status = AgentStatus.IDLE
    
    async def start(self) -> None:
        """Start the agent's message processing loop."""
        self.logger.info(f"Starting agent {self.name}")
        
        while True:
            message = await self.receive_message()
            if message:
                await self.handle_message(message)
            await asyncio.sleep(0.1)  # Small delay to prevent CPU spinning
    
    def get_status(self) -> Dict[str, Any]:
        """
        Get current status and metrics of the agent.
        
        Returns:
            Dict containing status and metrics
        """
        return {
            "name": self.name,
            "id": self.id,
            "status": self.status.value,
            "description": self.description,
            "capabilities": [cap.name for cap in self.capabilities],
            "metrics": self.metrics
        }
    
    def add_capability(self, capability: AgentCapability) -> None:
        """Add a capability to this agent."""
        self.capabilities.append(capability)
        self.logger.info(f"Added capability: {capability.name}")
    
    async def health_check(self) -> bool:
        """
        Perform a health check on the agent.
        
        Returns:
            bool: True if agent is healthy, False otherwise
        """
        try:
            return self.status != AgentStatus.ERROR
        except Exception as e:
            self.logger.error(f"Health check failed: {str(e)}")
            return False 