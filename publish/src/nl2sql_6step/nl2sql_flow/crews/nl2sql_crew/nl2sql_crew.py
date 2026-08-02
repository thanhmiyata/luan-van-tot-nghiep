import logging
import os
from crewai import Agent, Crew, Process, Task, LLM
from crewai.project import CrewBase, agent, crew, task
from crewai.agents.agent_builder.base_agent import BaseAgent
from typing import Any, Dict, List, Optional


ROLE_DEFAULT_MODELS = {
    # GPT-4o for intent/contracts; Flash elsewhere for budget stability.
    "question_analyzer": "openai/gpt-4o",
    "schema_selector": "gemini/gemini-flash-latest",
    "query_planner": "gemini/gemini-flash-latest",
    "sql_expert": "openai/gpt-4o",
    "sql_refiner": "gemini/gemini-flash-latest",
    "sql_validator": "gemini/gemini-flash-latest",
}

ROLE_FALLBACK_MODELS = {
    "question_analyzer": "gemini/gemini-flash-latest",
    "query_planner": "gemini/gemini-flash-latest",
    "sql_refiner": "gemini/gemini-flash-latest",
}

# Provider timeouts bound the actual HTTP request. The role-specific limits
# also avoid paying 4,096 output tokens for compact schema, SQL, and validation
# JSON responses.
ROLE_TIMEOUT_SECONDS = {
    "question_analyzer": 45,
    "schema_selector": 25,
    "query_planner": 30,
    "sql_expert": 25,
    "sql_refiner": 35,
    "sql_validator": 25,
}

ROLE_MAX_COMPLETION_TOKENS = {
    # gemini-flash-latest may spend tokens on thinking; keep headroom for JSON.
    "question_analyzer": 3072,
    "schema_selector": 2048,
    "query_planner": 3072,
    "sql_expert": 768,
    "sql_refiner": 2048,
    "sql_validator": 2048,
}

DEEPSEEK_DEFAULT_THINKING = {
    "question_analyzer": "disabled",
    "query_planner": "enabled",
}

_FALLBACK_EXCEPTION_NAMES = {
    "APIConnectionError",
    "APIError",
    "APITimeoutError",
    "AuthenticationError",
    "InternalServerError",
    "NotFoundError",
    "PermissionDeniedError",
    "RateLimitError",
    "ServiceUnavailableError",
    "Timeout",
}

_FALLBACK_MESSAGE_MARKERS = (
    "api connection",
    "authentication",
    "decommissioned",
    "does not exist",
    "invalid model",
    "model not found",
    "model_not_found",
    "not_found_error",
    "permission denied",
    "rate limit",
    "service unavailable",
    "timed out",
    "timeout",
)


def _env_bool(name: str, default: bool) -> bool:
    value = os.getenv(name)
    if value is None:
        return default
    normalized = value.strip().lower()
    if normalized in {"1", "true", "yes", "on", "enabled"}:
        return True
    if normalized in {"0", "false", "no", "off", "disabled"}:
        return False
    raise ValueError(
        f"{name} must be true/false, enabled/disabled, 1/0, yes/no, or on/off"
    )


def _env_int(
    role: str,
    suffix: str,
    default: int,
    *,
    legacy_global: Optional[str] = None,
) -> int:
    role_name = f"NL2SQL_{role.upper()}_{suffix}"
    raw_value = os.getenv(role_name)
    source_name = role_name
    if raw_value is None and legacy_global:
        raw_value = os.getenv(legacy_global)
        source_name = legacy_global
    if raw_value is None:
        return default
    try:
        value = int(raw_value)
    except ValueError as error:
        raise ValueError(f"{source_name} must be an integer") from error
    if value <= 0:
        raise ValueError(f"{source_name} must be greater than zero")
    return value


def _is_deepseek_model(model: str) -> bool:
    normalized = model.strip().lower()
    return normalized.startswith("deepseek/") or normalized.startswith("deepseek-")


def _should_use_fallback(error: Exception) -> bool:
    if type(error).__name__ in _FALLBACK_EXCEPTION_NAMES:
        return True
    message = str(error).lower()
    return any(marker in message for marker in _FALLBACK_MESSAGE_MARKERS)


class FallbackLLM(LLM):
    """Use one explicitly configured backup for provider availability failures."""

    def __init__(self, *args, fallback_llm: LLM, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.fallback_llm = fallback_llm

    def call(
        self,
        messages: str | List[Dict[str, str]],
        tools: Optional[List[Dict]] = None,
        callbacks: Optional[List[Any]] = None,
        available_functions: Optional[Dict[str, Any]] = None,
        from_task: Any | None = None,
        from_agent: Any | None = None,
    ) -> str | Any:
        try:
            return super().call(
                messages,
                tools=tools,
                callbacks=callbacks,
                available_functions=available_functions,
                from_task=from_task,
                from_agent=from_agent,
            )
        except Exception as error:
            if not _should_use_fallback(error):
                raise
            logging.warning(
                "Primary LLM %s unavailable (%s); using configured fallback %s",
                self.model,
                type(error).__name__,
                self.fallback_llm.model,
            )
            return self.fallback_llm.call(
                messages,
                tools=tools,
                callbacks=callbacks,
                available_functions=available_functions,
                from_task=from_task,
                from_agent=from_agent,
            )


# If you want to run a snippet of code before or after the crew starts,
# you can use the @before_kickoff and @after_kickoff decorators
# https://docs.crewai.com/concepts/crews#example-crew-class-with-decorators

@CrewBase
class Nl2SqlCrew():
    """Nl2SqlCrew crew"""

    agents: List[BaseAgent]
    tasks: List[Task]

    def __init__(
        self,
        model_overrides: Optional[Dict[str, str]] = None,
    ) -> None:
        self.model_overrides = self._validate_model_overrides(
            model_overrides
        )
        self.llm = None
        if os.getenv("USE_LOCAL_LLM") == "true":
            self.llm = LLM(
                model=os.getenv("LOCAL_LLM_MODEL", "openai/qwen-2.5-coder-14b"),
                base_url=os.getenv("LOCAL_LLM_BASE_URL", "http://localhost:1234/v1"),
                api_key="lm-studio"
            )

    @staticmethod
    def _validate_model_overrides(
        model_overrides: Optional[Dict[str, str]],
    ) -> Dict[str, str]:
        """Validate and copy per-instance role-to-model overrides."""
        if model_overrides is None:
            return {}
        if not isinstance(model_overrides, dict):
            raise TypeError("model_overrides must be a dictionary")

        unknown_roles = sorted(
            set(model_overrides) - set(ROLE_DEFAULT_MODELS)
        )
        if unknown_roles:
            raise ValueError(
                "Unsupported model override role(s): "
                + ", ".join(unknown_roles)
            )

        validated: Dict[str, str] = {}
        for role, model in model_overrides.items():
            if not isinstance(model, str) or not model.strip():
                raise ValueError(
                    f"Model override for {role} must be a non-empty string"
                )
            validated[role] = model.strip()
        return validated

    def _llm_for(self, role: str) -> LLM:
        """Create a budget-aware per-role model with environment overrides."""
        if role not in ROLE_DEFAULT_MODELS:
            raise ValueError(f"Unsupported NL2SQL role: {role}")
        if self.llm is not None and role not in self.model_overrides:
            return self.llm

        env_name = f"NL2SQL_{role.upper()}_MODEL"
        configured_model = self.model_overrides.get(
            role,
            os.getenv(env_name, ROLE_DEFAULT_MODELS[role]),
        ).strip()
        if not configured_model:
            raise ValueError(f"{env_name} cannot be empty")

        primary_kwargs = self._llm_kwargs(role, configured_model)
        fallback_model = os.getenv(
            f"NL2SQL_{role.upper()}_FALLBACK_MODEL",
            ROLE_FALLBACK_MODELS.get(role, ""),
        ).strip()
        fallback_enabled = _env_bool(
            "NL2SQL_ENABLE_MODEL_FALLBACKS", False
        ) and not _env_bool("NL2SQL_STRICT_BENCHMARK", False)
        if (
            not fallback_enabled
            or not fallback_model
            or fallback_model == configured_model
        ):
            return LLM(**primary_kwargs)

        fallback_kwargs = self._llm_kwargs(role, fallback_model)
        fallback_llm = LLM(**fallback_kwargs)
        return FallbackLLM(
            **primary_kwargs,
            fallback_llm=fallback_llm,
        )

    def _llm_kwargs(self, role: str, configured_model: str) -> Dict[str, Any]:
        """Build provider parameters without making a network request."""
        kwargs: Dict[str, Any] = {
            "model": configured_model,
            "timeout": _env_int(
                role,
                "TIMEOUT_SECONDS",
                ROLE_TIMEOUT_SECONDS[role],
                legacy_global="NL2SQL_LLM_TIMEOUT_SECONDS",
            ),
            "max_completion_tokens": _env_int(
                role,
                "MAX_COMPLETION_TOKENS",
                ROLE_MAX_COMPLETION_TOKENS[role],
                legacy_global="NL2SQL_MAX_COMPLETION_TOKENS",
            ),
        }

        # DeepSeek exposes an OpenAI-compatible endpoint. Using the generic
        # provider path also allows new low-cost model IDs with older LiteLLM.
        if _is_deepseek_model(configured_model):
            deepseek_model = (
                configured_model.split("/", 1)[1]
                if "/" in configured_model
                else configured_model
            )
            deepseek_api_key = os.getenv("DEEPSEEK_API_KEY", "").strip()
            if not deepseek_api_key:
                raise ValueError(
                    "DEEPSEEK_API_KEY is required for a DeepSeek model"
                )
            thinking_default = DEEPSEEK_DEFAULT_THINKING.get(
                role, "disabled"
            )
            thinking_value = os.getenv(
                f"NL2SQL_{role.upper()}_THINKING",
                os.getenv("NL2SQL_DEEPSEEK_THINKING", thinking_default),
            ).strip().lower()
            if thinking_value not in {"enabled", "disabled"}:
                raise ValueError(
                    f"NL2SQL_{role.upper()}_THINKING must be "
                    "enabled or disabled"
                )
            kwargs.update(
                {
                    "model": f"openai/{deepseek_model}",
                    "base_url": os.getenv(
                        "DEEPSEEK_BASE_URL", "https://api.deepseek.com"
                    ),
                    "api_key": deepseek_api_key,
                    "extra_body": {
                        "thinking": {"type": thinking_value}
                    },
                }
            )
            if thinking_value == "enabled":
                kwargs["reasoning_effort"] = os.getenv(
                    f"NL2SQL_{role.upper()}_REASONING_EFFORT",
                    os.getenv("NL2SQL_DEEPSEEK_REASONING_EFFORT", "high"),
                ).strip()
        else:
            reasoning_effort = os.getenv(
                f"NL2SQL_{role.upper()}_REASONING_EFFORT", ""
            ).strip()
            if reasoning_effort:
                kwargs["reasoning_effort"] = reasoning_effort
        return kwargs

    @agent
    def question_analyzer(self) -> Agent:
        return Agent(
            # type: ignore[index]
            config=self.agents_config['question_analyzer'],
            verbose=True,
            llm=self._llm_for("question_analyzer")
        )

    @agent
    def schema_selector(self) -> Agent:
        return Agent(
            # type: ignore[index]
            config=self.agents_config['schema_selector'],
            verbose=True,
            llm=self._llm_for("schema_selector")
        )

    @agent
    def sql_expert(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_expert'],  # type: ignore[index]
            verbose=True,
            llm=self._llm_for("sql_expert")
        )

    @agent
    def sql_validator(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_validator'],  # type: ignore[index]
            verbose=True,
            llm=self._llm_for("sql_validator")
        )

    @agent
    def query_planner(self) -> Agent:
        return Agent(
            config=self.agents_config['query_planner'],  # type: ignore[index]
            verbose=True,
            llm=self._llm_for("query_planner")
        )

    @agent
    def sql_refiner(self) -> Agent:
        return Agent(
            config=self.agents_config['sql_refiner'],  # type: ignore[index]
            verbose=True,
            llm=self._llm_for("sql_refiner")
        )

    @task
    def question_analysis_task(self) -> Task:
        from nl2sql_flow.main import QuestionAnalysisResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['question_analysis_task'],
            output_pydantic=QuestionAnalysisResult,
        )

    @task
    def select_needed_schema_task(self) -> Task:
        from nl2sql_flow.main import SchemaSelectionResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['select_needed_schema_task'],
            output_pydantic=SchemaSelectionResult,
        )

    @task
    def generate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLCandidates
        return Task(
            # type: ignore[index]
            config=self.tasks_config['generate_sql_task'],
            output_pydantic=NL2SQLCandidates,
        )

    @task
    def validate_sql_task(self) -> Task:
        from nl2sql_flow.main import NL2SQLResult
        return Task(
            # type: ignore[index]
            config=self.tasks_config['validate_sql_task'],
            output_pydantic=NL2SQLResult,
        )

    @task
    def query_planning_task(self) -> Task:
        from nl2sql_flow.main import QueryPlanResult
        return Task(
            config=self.tasks_config['query_planning_task'],  # type: ignore[index]
            output_pydantic=QueryPlanResult,
        )

    @task
    def refine_sql_task(self) -> Task:
        from nl2sql_flow.main import RefinedSQLResult
        return Task(
            config=self.tasks_config['refine_sql_task'],  # type: ignore[index]
            output_pydantic=RefinedSQLResult,
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
