import os
from crewai import Agent, Crew, Process, Task, LLM
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

    def __init__(self) -> None:
        self.llm = None
        if os.getenv("USE_LOCAL_LLM") == "true":
            self.llm = LLM(
                model=os.getenv("LOCAL_LLM_MODEL", "openai/qwen-2.5-coder-14b"),
                base_url=os.getenv("LOCAL_LLM_BASE_URL", "http://localhost:1234/v1"),
                api_key="lm-studio"
            )

    @agent
    def question_analyzer(self) -> Agent:
        return Agent(
            # type: ignore[index]
            config=self.agents_config['question_analyzer'],
            verbose=True,
            llm=self.llm
        )

    @agent
    def schema_selector(self) -> Agent:
        return Agent(
            # type: ignore[index]
            config=self.agents_config['schema_selector'],
            verbose=True,
            llm=self.llm
        )

    @agent
    def sql_expert(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_expert'],  # type: ignore[index]
            verbose=True,
            llm=self.llm
        )

    @agent
    def sql_validator(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_validator'],  # type: ignore[index]
            verbose=True,
            llm=self.llm
        )

    @agent
    def query_planner(self) -> Agent:
        return Agent(
            config=self.agents_config['query_planner'],  # type: ignore[index]
            verbose=True,
            llm=self.llm
        )

    @agent
    def sql_refiner(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_refiner'],  # type: ignore[index]
            verbose=True,
            llm=self.llm
        )

    @task
    def question_analysis_task(self) -> Task:
        from nl2sql_flow.main import QuestionAnalysisResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['question_analysis_task'],
        )

    @task
    def select_needed_schema_task(self) -> Task:
        from nl2sql_flow.main import SQLDbSchema
        return Task(
            # type: ignore[index]
            config=self.tasks_config['select_needed_schema_task'],
        )

    @task
    def generate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLOnlyResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['generate_sql_task'],
        )

    @task
    def validate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['validate_sql_task'],
        )

    @task
    def query_planning_task(self) -> Task:
        from nl2sql_flow.main import QueryPlanResult
        return Task(
            config=self.tasks_config['query_planning_task'],  # type: ignore[index]
        )

    @task
    def refine_sql_task(self) -> Task:
        from nl2sql_flow.main import RefinedSQLResult
        return Task(
            config=self.tasks_config['refine_sql_task'],  # type: ignore[index]
        )


    @crew
    def question_analysis_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            # Automatically created by the @task decorator
            tasks=[self.question_analysis_task()],
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def select_needed_schema_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            # Automatically created by the @task decorator
            tasks=[self.select_needed_schema_task()],
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def generated_sql_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            # Automatically created by the @task decorator
            tasks=[self.generate_sql_task()],
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def validate_sql_crew(self) -> Crew:
        return Crew(
            agents=self.agents,  # Automatically created by the @agent decorator
            # Automatically created by the @task decorator
            tasks=[self.validate_sql_task()],
            process=Process.sequential,
            # verbose=True,
            # process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
        )

    @crew
    def query_planning_crew(self) -> Crew:
        return Crew(
            agents=self.agents,
            tasks=[self.query_planning_task()],
            process=Process.sequential,
        )

    @crew
    def sql_refinement_crew(self) -> Crew:
        return Crew(
            agents=self.agents,
            tasks=[self.refine_sql_task()],
            process=Process.sequential,
        )
