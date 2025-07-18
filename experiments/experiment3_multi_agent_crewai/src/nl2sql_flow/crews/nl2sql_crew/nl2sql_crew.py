from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task
from crewai.agents.agent_builder.base_agent import BaseAgent
from typing import List



# If you want to run a snippet of code before or after the crew starts,
# you can use the @before_kickoff and @after_kickoff decorators
# https://docs.crewai.com/concepts/crews#example-crew-class-with-decorators

@CrewBase
class Nl2SqlCrew():
    """Nl2SqlCrew crew"""

    agents: List[BaseAgent]
    tasks: List[Task]

    @agent
    def schema_selector(self) -> Agent:
        return Agent(
            config=self.agents_config['schema_selector'],  # type: ignore[index]
            verbose=True
        )

    @agent
    def sql_expert(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_expert'],  # type: ignore[index]
            verbose=True
        )

    @agent
    def sql_validator(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_validator'],  # type: ignore[index]
            verbose=True
        )

    @task
    def select_needed_schema_task(self) -> Task:
        from nl2sql_flow.main import SQLDbSchema
        return Task(
            config=self.tasks_config['select_needed_schema_task'],  # type: ignore[index]
            output_json=SQLDbSchema
        )

    @task
    def generate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLOnlyResult
        return Task(
            config=self.tasks_config['generate_sql_task'],  # type: ignore[index]
            output_json=NL2SQLOnlyResult
        )

    @task
    def validate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLResult
        return Task(
            config=self.tasks_config['validate_sql_task'],  # type: ignore[index]
            output_json=NL2SQLResult
        )

    @crew
    def select_needed_schema_screw(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            tasks=[self.select_needed_schema_task()],  # Automatically created by the @task decorator
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def generated_sql_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            tasks=[self.generate_sql_task()],  # Automatically created by the @task decorator
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def validate_sql_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            tasks=[self.validate_sql_task()],  # Automatically created by the @task decorator
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )