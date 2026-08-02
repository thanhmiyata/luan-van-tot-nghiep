# Ablation full per-DB comparison


> **Model policy update 2026-07-30:** from `network_1` onward use agents.yaml (Planner/Refiner/Validator=Gemini Flash; Planned=GPT-4o). DBs world_1…wta_1 were all-GPT-4o override — kept; not re-run.

5-stage ablations reuse 4-step early-stage outputs (Analyzer/Schema/Direct).

### world_1
- time: 2026-07-30T01:46:30
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 73.3 | 49.2 | 120 |
| 5-stage w/o Planner | 75.0 | 46.7 | 120 |
| 5-stage w/o Refiner | 73.3 | 47.5 | 120 |
| 6-step locked | 80.0 | 62.5 | 120 |

- ΔEX vs 4-step: no_planner=+1.7  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=-5.0  no_refiner=-6.7

### car_1
- time: 2026-07-30T01:46:30
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 79.3 | 42.4 | 92 |
| 5-stage w/o Planner | 80.4 | 35.9 | 92 |
| 5-stage w/o Refiner | 78.3 | 34.8 | 92 |
| 6-step locked | 85.9 | 51.1 | 92 |

- ΔEX vs 4-step: no_planner=+1.1  no_refiner=-1.0
- ΔEX vs 6-step: no_planner=-5.5  no_refiner=-7.6

### cre_Doc_Template_Mgt
- time: 2026-07-30T01:52:55
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 83.3 | 56.0 | 84 |
| 5-stage w/o Planner | 88.1 | 36.9 | 84 |
| 5-stage w/o Refiner | 88.1 | 36.9 | 84 |
| 6-step locked | 88.1 | 73.8 | 84 |

- ΔEX vs 4-step: no_planner=+4.8  no_refiner=+4.8
- ΔEX vs 6-step: no_planner=+0.0  no_refiner=+0.0

### dog_kennels
- time: 2026-07-30T02:01:05
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 81.7 | 58.5 | 82 |
| 5-stage w/o Planner | 76.8 | 42.7 | 82 |
| 5-stage w/o Refiner | 78.0 | 42.7 | 82 |
| 6-step locked | 85.4 | 67.1 | 82 |

- ΔEX vs 4-step: no_planner=-4.9  no_refiner=-3.7
- ΔEX vs 6-step: no_planner=-8.6  no_refiner=-7.4

### flight_2
- time: 2026-07-30T02:07:36
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 88.7 | 71.3 | 80 |
| 5-stage w/o Planner | 88.7 | 56.2 | 80 |
| 5-stage w/o Refiner | 87.5 | 57.5 | 80 |
| 6-step locked | 87.5 | 86.3 | 80 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=-1.2
- ΔEX vs 6-step: no_planner=+1.2  no_refiner=+0.0

### student_transcripts_tracking
- time: 2026-07-30T02:16:15
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 78.2 | 47.4 | 78 |
| 5-stage w/o Planner | 78.2 | 39.7 | 78 |
| 5-stage w/o Refiner | 78.2 | 41.0 | 78 |
| 6-step locked | 83.3 | 66.7 | 78 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=-5.1  no_refiner=-5.1

### tvshow
- time: 2026-07-30T02:18:58
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 77.4 | 58.1 | 62 |
| 5-stage w/o Planner | 82.3 | 51.6 | 62 |
| 5-stage w/o Refiner | 83.9 | 51.6 | 62 |
| 6-step locked | 88.7 | 83.9 | 62 |

- ΔEX vs 4-step: no_planner=+4.9  no_refiner=+6.5
- ΔEX vs 6-step: no_planner=-6.4  no_refiner=-4.8

### wta_1
- time: 2026-07-30T02:25:54
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 88.7 | 74.2 | 62 |
| 5-stage w/o Planner | 90.3 | 53.2 | 62 |
| 5-stage w/o Refiner | 90.3 | 51.6 | 62 |
| 6-step locked | 91.9 | 80.6 | 62 |

- ΔEX vs 4-step: no_planner=+1.6  no_refiner=+1.6
- ΔEX vs 6-step: no_planner=-1.6  no_refiner=-1.6

### network_1
- time: 2026-07-30T02:46:31
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 82.1 | 48.2 | 56 |
| 5-stage w/o Planner | 82.1 | 37.5 | 56 |
| 5-stage w/o Refiner | 85.7 | 41.1 | 56 |
| 6-step locked | 89.3 | 69.6 | 56 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+3.6
- ΔEX vs 6-step: no_planner=-7.2  no_refiner=-3.6

### concert_singer
- time: 2026-07-30T02:58:48
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 93.3 | 57.8 | 45 |
| 5-stage w/o Planner | 93.3 | 44.4 | 45 |
| 5-stage w/o Refiner | 91.1 | 46.7 | 45 |
| 6-step locked | 95.6 | 80.0 | 45 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=-2.2
- ΔEX vs 6-step: no_planner=-2.3  no_refiner=-4.5

### pets_1
- time: 2026-07-30T03:10:37
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 97.6 | 52.4 | 42 |
| 5-stage w/o Planner | 97.6 | 35.7 | 42 |
| 5-stage w/o Refiner | 97.6 | 33.3 | 42 |
| 6-step locked | 97.6 | 81.0 | 42 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=+0.0  no_refiner=+0.0

### orchestra
- time: 2026-07-30T03:17:35
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 90.0 | 57.5 | 40 |
| 5-stage w/o Planner | 87.5 | 50.0 | 40 |
| 5-stage w/o Refiner | 87.5 | 52.5 | 40 |
| 6-step locked | 90.0 | 85.0 | 40 |

- ΔEX vs 4-step: no_planner=-2.5  no_refiner=-2.5
- ΔEX vs 6-step: no_planner=-2.5  no_refiner=-2.5

### poker_player
- time: 2026-07-30T03:22:35
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 97.5 | 80.0 | 40 |
| 5-stage w/o Planner | 97.5 | 70.0 | 40 |
| 5-stage w/o Refiner | 97.5 | 70.0 | 40 |
| 6-step locked | 100.0 | 95.0 | 40 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=-2.5  no_refiner=-2.5

### employee_hire_evaluation
- time: 2026-07-30T03:30:07
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 94.7 | 65.8 | 38 |
| 5-stage w/o Planner | 97.4 | 47.4 | 38 |
| 5-stage w/o Refiner | 97.4 | 47.4 | 38 |
| 6-step locked | 100.0 | 84.2 | 38 |

- ΔEX vs 4-step: no_planner=+2.7  no_refiner=+2.7
- ΔEX vs 6-step: no_planner=-2.6  no_refiner=-2.6

### course_teach
- time: 2026-07-30T03:35:55
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 96.7 | 60.0 | 30 |
| 5-stage w/o Planner | 100.0 | 60.0 | 30 |
| 5-stage w/o Refiner | 100.0 | 60.0 | 30 |
| 6-step locked | 96.7 | 90.0 | 30 |

- ΔEX vs 4-step: no_planner=+3.3  no_refiner=+3.3
- ΔEX vs 6-step: no_planner=+3.3  no_refiner=+3.3

### singer
- time: 2026-07-30T03:40:34
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 96.7 | 63.3 | 30 |
| 5-stage w/o Planner | 93.3 | 56.7 | 30 |
| 5-stage w/o Refiner | 93.3 | 56.7 | 30 |
| 6-step locked | 100.0 | 96.7 | 30 |

- ΔEX vs 4-step: no_planner=-3.4  no_refiner=-3.4
- ΔEX vs 6-step: no_planner=-6.7  no_refiner=-6.7

### museum_visit
- time: 2026-07-30T03:45:01
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 94.4 | 77.8 | 18 |
| 5-stage w/o Planner | 94.4 | 50.0 | 18 |
| 5-stage w/o Refiner | 94.4 | 50.0 | 18 |
| 6-step locked | 88.9 | 88.9 | 18 |

- ΔEX vs 4-step: no_planner=-0.0  no_refiner=-0.0
- ΔEX vs 6-step: no_planner=+5.5  no_refiner=+5.5

### battle_death
- time: 2026-07-30T03:47:17
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 81.2 | 50.0 | 16 |
| 5-stage w/o Planner | 75.0 | 37.5 | 16 |
| 5-stage w/o Refiner | 75.0 | 37.5 | 16 |
| 6-step locked | 87.5 | 75.0 | 16 |

- ΔEX vs 4-step: no_planner=-6.2  no_refiner=-6.2
- ΔEX vs 6-step: no_planner=-12.5  no_refiner=-12.5

### voter_1
- time: 2026-07-30T03:50:13
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 100.0 | 60.0 | 15 |
| 5-stage w/o Planner | 100.0 | 53.3 | 15 |
| 5-stage w/o Refiner | 100.0 | 53.3 | 15 |
| 6-step locked | 100.0 | 93.3 | 15 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=+0.0  no_refiner=+0.0

### real_estate_properties
- time: 2026-07-30T03:51:01
- seed: no_planner=100.0%  no_refiner=100.0%

| Config | EX | EM | n |
|---|---:|---:|---:|
| 4-step locked | 50.0 | 25.0 | 4 |
| 5-stage w/o Planner | 50.0 | 25.0 | 4 |
| 5-stage w/o Refiner | 50.0 | 25.0 | 4 |
| 6-step locked | 50.0 | 50.0 | 4 |

- ΔEX vs 4-step: no_planner=+0.0  no_refiner=+0.0
- ΔEX vs 6-step: no_planner=+0.0  no_refiner=+0.0

