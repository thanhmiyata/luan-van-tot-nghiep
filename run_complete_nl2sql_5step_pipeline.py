#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Thin wrapper → ``run_complete_nl2sql_pipeline.py`` for 5-step aliases.

Prefer the unified entry point:

  python run_complete_nl2sql_pipeline.py --pipeline without_planner --next
  python run_complete_nl2sql_pipeline.py --pipeline without_refiner --run-db world_1
  python run_complete_nl2sql_pipeline.py --pipeline 5step_without_planner --status
  python run_complete_nl2sql_pipeline.py --pipeline 5step_without_refiner --aggregate

This file only remaps legacy ``--pipeline without_*`` invocations.
"""

from __future__ import annotations

import sys

# Re-export unified runner; argv already contains --pipeline without_* / 5step_*
import run_complete_nl2sql_pipeline as pl


def main() -> None:
    # If user forgot --pipeline, default to without_planner for this wrapper.
    if "--pipeline" not in sys.argv:
        sys.argv.extend(["--pipeline", "without_planner"])
    pl.main()


if __name__ == "__main__":
    main()
