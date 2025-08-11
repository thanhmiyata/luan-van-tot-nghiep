from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task
from crewai.agents.agent_builder.base_agent import BaseAgent
from typing import List

@CrewBase
class Nl2SqlCrew():
    """Single Agent NL2SQL Crew"""

    agents: List[BaseAgent]
    tasks: List[Task]

    @agent
    def nl2sql_agent(self) -> Agent:
        return Agent(
            config=self.agents_config['nl2sql_agent'],  # type: ignore[index]
            verbose=True
        )

    @task
    def nl2sql_task(self) -> Task:
        from nl2sql_single_agent.main import NL2SQLResult
        return Task(
            config=self.tasks_config['nl2sql_task'],  # type: ignore[index]
            output_json=NL2SQLResult
        )

    @crew
    def nl2sql_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            tasks=[self.nl2sql_task()],  # Automatically created by the @task decorator
            process=Process.sequential,
        ) 