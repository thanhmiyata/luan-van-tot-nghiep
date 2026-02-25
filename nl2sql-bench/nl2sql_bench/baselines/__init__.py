"""Baseline NL2SQL systems for comparison."""

__all__ = []

# Optional imports - only available if baselines dependencies are installed
try:
    from nl2sql_bench.baselines.multi_agent_6step import MultiAgent6StepSystem
    __all__.append("MultiAgent6StepSystem")
except ImportError:
    pass
