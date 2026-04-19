# Benchmark Matrix for Mixed-Model NL2SQL

Muc tieu cua file nay la giup chay benchmark co kiem soat de bo sung so lieu cho cac bang trong bai bao.

## Nguyen tac chay

- Co dinh cung `db_id` giua cac lan chay.
- Co dinh cung `seed` de lay cung mot tap cau hoi.
- Giu nguyen prompt/task format; chi thay doi `agents.yaml` theo cau hinh can test.
- Dung cung pipeline `6step` cho cac ablation 5/6 buoc; dung `4step` cho baseline 4 buoc.
- Do `temperature = 0`, moi lan chay nen co tinh on dinh cao hon, nhung van nen giu cung input subset de so sanh cong bang.

## Ma tran cau hinh de chay

| ID | Muc tieu | Analyzer | Schema | Planner | Generator | Refiner | Validator | Bang trong paper |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| B1 | Single prompt direct baseline | - | - | - | `openai/gpt-4o` | - | - | Prompting baseline |
| B2 | Single prompt CoT baseline | - | - | - | `openai/gpt-4o` | - | - | Prompting baseline |
| B3 | 4-step baseline cong bang voi main system | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | - | `openai/gpt-4o` | - | `anthropic/claude-sonnet-4-20250514` | Main comparison, ablation |
| B4 | 5-step without Planner | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | - | `openai/gpt-4o` | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | Ablation |
| B5 | 5-step without Refiner | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | `openai/gpt-4o` | - | `anthropic/claude-sonnet-4-20250514` | Ablation |
| B6 | 6-step main mixed-model (current best subset run) | `openai/gpt-4o` | `gemini/gemini-2.5-flash` | `openai/gpt-4o` | `openai/gpt-4o` | `openai/gpt-4o` | `gemini/gemini-2.5-flash` | Main result / locked subset winner |
| B7 | 6-step exploratory, DeepSeek o reasoning-heavy steps | `anthropic/claude-sonnet-4-20250514` | `anthropic/claude-sonnet-4-20250514` | `deepseek/deepseek-reasoner` | `openai/gpt-4o` | `deepseek/deepseek-reasoner` | `anthropic/claude-sonnet-4-20250514` | Exploratory / appendix |
| B8 | 6-step cost-quality alternative | `gemini/gemini-3.0-preview` | `gemini/gemini-3.0-preview` | `anthropic/claude-sonnet-4-20250514` | `openai/gpt-4o` | `anthropic/claude-sonnet-4-20250514` | `gemini/gemini-3.0-preview` | Cost-quality discussion |

## Thu tu chay khuyen nghi

1. `B3`
2. `B4`
3. `B5`
4. `B6`
5. `B1`
6. `B2`
7. `B7`
8. `B8`

Neu ngan sach han che, chi can chay:

- `B1`
- `B2`
- `B3`
- `B4`
- `B5`
- `B6`

## Mapping sang cac bang trong paper

- Main architecture table: `B3` vs `B6`
- Ablation table: `B3`, `B4`, `B5`, `B6`
- Prompting baseline table: `B1`, `B2`, `B3`, `B6`
- Cost/latency table: it nhat `B1`, `B2`, `B3`, `B6`
- Discussion ve model choice: bo sung `B7`, `B8`

## Cach chay cong bang tren cung mot database

Script `run_complete_nl2sql_pipeline.py` da duoc cap nhat de ho tro:

- `--db_id`: co dinh mot database Spider
- `--seed`: co dinh cach lay mau cau hoi trong database do

Vi du:

```bash
python run_complete_nl2sql_pipeline.py --pipeline 6step --db_id music_1 --num_questions 50 --seed 42
```

Sau do doi cau hinh model trong `src/nl2sql_6step/nl2sql_flow/crews/nl2sql_crew/config/agents.yaml` va chay lai cung lenh tren de so sanh cong bang.

## Goi y quy trinh test

1. Chon `db_id` co so luong cau hoi du nhieu.
2. Chay `B6` truoc de lay moc chat luong tot nhat.
3. Chay `B4` va `B5` de tach dong gop cua `Planner` va `Refiner`.
4. Chay `B3` de co cap doi sanh `4-step` vs `6-step`.
5. Neu can viet phan discussion ve model assignment, chay them `B7` va `B8`.

## Log nen luu sau moi lan chay

- `pipeline`
- `db_id`
- `num_questions`
- `seed`
- mapping model theo tung step
- `EX`
- `EM`
- tong thoi gian chay
- tong agent calls
- file output CSV, `gold.sql`, `predict.sql`

## Nhan dinh truoc khi chay

- `B4` giam so voi `B6` se ho tro luan diem ve gia tri cua `Planner`.
- `B5` giam so voi `B6` se ho tro luan diem ve gia tri cua `Refiner`.
- `B3 -> B6` la cap reviewer de chap nhan nhat cho lap luan ve loi ich kien truc.
- `B7` co the cho EX thu vi, nhung chua chac tot hon ve EM.

## Ket qua da chay

### Single-prompt NL2SQL (Gemini 2.5 Flash, `run_single_prompt_nl2sql.py`)

Cac lan chay duoi day la baseline **mot prompt / mot cau hoi** (khong phai pipeline da tac nhan). Dung de doi chieu noi bo voi cac run `6step` / `4step`; **khong** tron truc tiep voi bang main-result full-dev (1034 cau, nhieu DB).

#### Muc tieu: phu kin Spider dev (1034 cau) bang tung database

- File cau hoi: `output/questions_dev.json` — **1034** cau, nhieu `db_id`.
- **Chien luoc uu tien:** chay **tung `--db-id`** (nhu cac lan SP2–SP6), moi lan mot DB day du cau hoi trong dev; ghi EX/EM vao bang tong hop theo tung DB. Cach nay de kiem soat thoi gian, rate limit va so sanh theo domain.
- **Tuy chon (khong bat buoc):** mot lan chay **khong** `--db-id` de co mot cap `gold.sql` / `predict.sql` tren **ca** 1034 cau va mot dong EX/EM **all** duy nhat — ton ~**1034** lan goi API va **~40–60 phut**; chi dung khi thuc su can so tong hop mot phat.
- Lenh full 1034 (tham khao; Gemini 2.5 Flash; co the dieu chinh `--delay`):

```bash
source venv/bin/activate
python run_single_prompt_nl2sql.py \
  --provider gemini \
  --model gemini-2.5-flash \
  --out-dir output/nl2sql_single_prompt_spider_dev_full_gemini25 \
  --delay 0.15
```

- Danh gia (tu thu muc goc repo, sau khi co `gold.sql` / `predict.sql`):

```bash
python experiments/test-suite-sql-eval/evaluation.py \
  --gold output/nl2sql_single_prompt_spider_dev_full_gemini25/gold.sql \
  --pred output/nl2sql_single_prompt_spider_dev_full_gemini25/predict.sql \
  --db experiments/test-suite-sql-eval/database \
  --etype all \
  --table experiments/test-suite-sql-eval/tables.json \
  --plug_value
```

- Khi full run hoan tat, bo sung mot hang vao bang tong hop (vi du `SP-full-dev`) voi EX/EM tren **all** 1034.

**Luu y:** ket qua single-prompt tren **`flight_2`** voi **subset 50 cau, `seed = 42`** (log cu: **SP1**) **khong** dua vao bang tong hop — trung lap voi cac run pipeline tren cung subset/seed. **`SP2`** (full **80** cau `flight_2` trong dev) **van** ghi trong bang va tinh trong **Tong hop SP2–SP20**.

#### SP2 — `flight_2`, full 80 cau (toan bo cau hoi dev cho DB nay)

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `flight_2`
- `num_questions`: `80` (full)
- `output`: `output/nl2sql_single_prompt_flight2_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 26 | 100.0 | 100.0 |
| Medium | 30 | 100.0 | 53.3 |
| Hard | 8 | 87.5 | 25.0 |
| Extra | 16 | 62.5 | 12.5 |
| **All** | **80** | **91.2** | **57.5** |

#### SP3 — `world_1`, full 120 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `world_1`
- `num_questions`: `120` (full trong dev — DB lon nhat trong Spider dev theo so cau)
- `elapsed_time` (wall, ~120 lan goi API): ~`267s` (~`4.5` phut)
- `output`: `output/nl2sql_single_prompt_world1_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 24 | 100.0 | 83.3 |
| Medium | 46 | 91.3 | 60.9 |
| Hard | 20 | 75.0 | 30.0 |
| Extra | 30 | 60.0 | 6.7 |
| **All** | **120** | **82.5** | **46.7** |

Nhan xet:

- `world_1` kho hon voi single-prompt so voi `flight_2` full (SP2): EX **82.5** vs **91.2**, EM **46.7** vs **57.5** — dung voi viec DB nay co nhieu cau **Hard/Extra** hon (20+30 vs 8+16 tren tong so cau).

#### SP4 — `car_1`, full 92 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `car_1`
- `num_questions`: `92` (full trong dev — DB lon thu hai sau `world_1` theo so cau)
- `elapsed_time` (wall, ~92 lan goi API): ~`269s` (~`4.5` phut)
- `output`: `output/nl2sql_single_prompt_car1_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 18 | 94.4 | 61.1 |
| Medium | 32 | 68.8 | 25.0 |
| Hard | 16 | 62.5 | 0.0 |
| Extra | 26 | 65.4 | 7.7 |
| **All** | **92** | **71.7** | **22.8** |

Nhan xet:

- `car_1` rat kho voi single-prompt: EM tong **22.8%**, EX **71.7%** — thap hon ro `flight_2` full (SP2) va `world_1` (SP3); nhom **Hard** EM **0%** (16/16 khong exact-match theo Spider parser).
- Phu hop de lam vi du "domain / schema phuc tap + nhieu cau hard" trong discussion, khong nen dua mot minh lam moc tong quat cho toan benchmark.

#### SP5 — `cre_Doc_Template_Mgt`, full 84 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `cre_Doc_Template_Mgt` (chua dung trong cac lan SP2–SP4: `flight_2`, `world_1`, `car_1`)
- `num_questions`: `84` (full trong dev)
- `elapsed_time` (wall, ~84 lan goi API): ~`177s` (~`3.0` phut)
- `output`: `output/nl2sql_single_prompt_cre_Doc_Template_Mgt_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 24 | 95.8 | 79.2 |
| Medium | 44 | 88.6 | 27.3 |
| Hard | 10 | 100.0 | 20.0 |
| Extra | 6 | 83.3 | 0.0 |
| **All** | **84** | **91.7** | **39.3** |

Nhan xet:

- EX tong **91.7%** gan sat `flight_2` full (SP2, **91.2%**), cao hon `car_1` (SP4); EM **39.3%** o giua `world_1` (SP3) va `car_1` (SP4).
- It cau **Extra** (6) trong DB nay nen khong nen so sanh truc tiep split Extra voi cac DB khac.

#### SP6 — `dog_kennels`, full 82 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `dog_kennels` (chua trung voi SP2–SP5: `flight_2`, `world_1`, `car_1`, `cre_Doc_Template_Mgt`)
- `num_questions`: `82` (full trong dev)
- `elapsed_time` (wall, ~82 lan goi API): ~`206s` (~`3.4` phut)
- `output`: `output/nl2sql_single_prompt_dog_kennels_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 10 | 100.0 | 100.0 |
| Medium | 36 | 88.9 | 44.4 |
| Hard | 10 | 60.0 | 30.0 |
| Extra | 26 | 65.4 | 0.0 |
| **All** | **82** | **79.3** | **35.4** |

Nhan xet:

- EX **79.3%** thap hon `flight_2` (SP2) / `cre_Doc_Template_Mgt` (SP5); nhieu cau **Extra** (26/82) keo EX/EM.
- Nhom **Extra** EM **0%** — giong xu huong `car_1` (SP4): single-prompt kho khop canonical tren cau phuc tap.

#### SP7 — `student_transcripts_tracking`, full 78 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `student_transcripts_tracking` (DB tiep theo sau `dog_kennels` theo so cau trong dev)
- `num_questions`: `78` (full trong dev)
- `elapsed_time` (wall, ~78 lan goi API): ~`201s` (~`3.4` phut)
- `output`: `output/nl2sql_single_prompt_student_transcripts_tracking_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 26 | 84.6 | 61.5 |
| Medium | 24 | 83.3 | 54.2 |
| Hard | 8 | 75.0 | 25.0 |
| Extra | 20 | 40.0 | 0.0 |
| **All** | **78** | **71.8** | **39.7** |

Nhan xet:

- EX tong **71.8%** gan `car_1` (SP4, **71.7%**); EM **39.7%** gan `cre_Doc_Template_Mgt` (SP5, **39.3%**).
- Nhom **Extra** (20 cau) EX **40%**, EM **0%** — single-prompt yeu o cau phuc tap tren DB nay.

#### SP8 — `wta_1`, full 62 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `wta_1`
- `num_questions`: `62` (full trong dev)
- `elapsed_time` (wall, ~62 lan goi API): ~`134s` (~`2.2` phut)
- `output`: `output/nl2sql_single_prompt_wta_1_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 16 | 93.8 | 56.2 |
| Medium | 30 | 86.7 | 66.7 |
| Hard | 14 | 64.3 | 14.3 |
| Extra | 2 | 100.0 | 50.0 |
| **All** | **62** | **83.9** | **51.6** |

Nhan xet:

- EX **83.9%** / EM **51.6%** cao hon nhieu DB kho nhu `student_transcripts_tracking` (SP7); it cau **Extra** (2) nen khong nen suy rong tu split Extra.

#### SP9 — `tvshow`, full 62 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `tvshow`
- `num_questions`: `62` (full trong dev; cung so cau voi `wta_1`)
- `elapsed_time` (wall, ~62 lan goi API): ~`127s` (~`2.1` phut)
- `output`: `output/nl2sql_single_prompt_tvshow_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 20 | 90.0 | 85.0 |
| Medium | 30 | 96.7 | 60.0 |
| Hard | 10 | 80.0 | 50.0 |
| Extra | 2 | 0.0 | 0.0 |
| **All** | **62** | **88.7** | **64.5** |

Nhan xet:

- EX **88.7%** / EM **64.5%** cao hon `wta_1` (SP8); chi co **2** cau **Extra** — split Extra khong on dinh thong ke.

#### SP10 — `network_1`, full 56 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `network_1`
- `num_questions`: `56` (full trong dev)
- `elapsed_time` (wall, ~56 lan goi API): ~`144s` (~`2.4` phut)
- `output`: `output/nl2sql_single_prompt_network_1_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 12 | 91.7 | 83.3 |
| Medium | 22 | 72.7 | 18.2 |
| Hard | 16 | 68.8 | 37.5 |
| Extra | 6 | 66.7 | 0.0 |
| **All** | **56** | **75.0** | **35.7** |

Nhan xet:

- EX **75.0%** / EM **35.7%** thap hon `tvshow` (SP9); **Medium** EM **18.2%** — nhieu cau trung binh khong khop canonical.

#### SP11 — `concert_singer`, full 45 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `concert_singer`
- `num_questions`: `45` (full trong dev)
- `elapsed_time` (wall, ~45 lan goi API): ~`90s` (~`1.5` phut)
- `output`: `output/nl2sql_single_prompt_concert_singer_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 4 | 100.0 | 100.0 |
| Medium | 24 | 95.8 | 66.7 |
| Hard | 13 | 100.0 | 61.5 |
| Extra | 4 | 100.0 | 25.0 |
| **All** | **45** | **97.8** | **64.4** |

Nhan xet:

- EX **97.8%** / EM **64.4%** — DB nho, nhieu cau **Easy/Hard** nen EX rat cao; van phu hop muc **>40** cau trong bang tong hop.

#### SP12 — `pets_1`, full 42 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `pets_1`
- `num_questions`: `42` (full trong dev)
- `elapsed_time` (wall, ~42 lan goi API): ~`100s` (~`1.7` phut)
- `output`: `output/nl2sql_single_prompt_pets_1_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 4 | 100.0 | 100.0 |
| Medium | 22 | 95.5 | 50.0 |
| Hard | 6 | 100.0 | 0.0 |
| Extra | 10 | 90.0 | 30.0 |
| **All** | **42** | **95.2** | **42.9** |

Nhan xet:

- EX **95.2%** rat cao; EM **42.9%** — nhom **Hard** (6 cau) EM **0%** (khong trung canonical du EX dung nhieu cau).

#### SP13 — `poker_player`, full 40 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `poker_player`
- `num_questions`: `40` (full trong dev; khong co cau **Extra** trong nhan hardness Spider cho DB nay)
- `elapsed_time` (wall, ~40 lan goi API): ~`75s` (~`1.3` phut)
- `output`: `output/nl2sql_single_prompt_poker_player_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 16 | 100.0 | 100.0 |
| Medium | 16 | 100.0 | 81.2 |
| Hard | 8 | 100.0 | 12.5 |
| Extra | 0 | — | — |
| **All** | **40** | **100.0** | **75.0** |

Nhan xet:

- **EX 100%** tren toan bo 40 cau; EM **75.0%** — moc single-prompt rat tot tren DB nay (schema tuong doi gon).

#### SP14 — `orchestra`, full 40 cau

- `script`: `run_single_prompt_nl2sql.py`
- `provider` / `model`: `gemini` / `gemini-2.5-flash`
- `db_id`: `orchestra`
- `num_questions`: `40` (full trong dev)
- `elapsed_time` (wall, ~40 lan goi API): ~`76s` (~`1.3` phut)
- `output`: `output/nl2sql_single_prompt_orchestra_gemini25_full/` (`gold.sql`, `predict.sql`)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 14 | 100.0 | 100.0 |
| Medium | 18 | 94.4 | 55.6 |
| Hard | 6 | 100.0 | 33.3 |
| Extra | 2 | 100.0 | 0.0 |
| **All** | **40** | **97.5** | **65.0** |

Nhan xet:

- EX **97.5%** / EM **65.0%** — thap hon mot chut so voi `poker_player` (SP13) ve EX, EM van cao.

#### Hoan tat cac database dev con lai (single-prompt Gemini 2.5 Flash)

Lan luot: chay `run_single_prompt_nl2sql.py` theo tung `--db-id` → `evaluation.py` → ghi lai duoi day. **SP15–SP20** bo sung **6** DB; **`real_estate_properties`** (chi **4** cau trong dev) **khong** dua vao bang — mau qua nho, khong co y nghia benchmark. Subset **`flight_2` 50 cau / seed 42** khong tinh tong hop (xem luu y o tren).

##### SP15 — `employee_hire_evaluation`, 38 cau — ~`74s`

- `output`: `output/nl2sql_single_prompt_employee_hire_evaluation_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 10 | 100.0 | 100.0 |
| Medium | 14 | 100.0 | 71.4 |
| Hard | 10 | 100.0 | 60.0 |
| Extra | 4 | 100.0 | 0.0 |
| **All** | **38** | **100.0** | **68.4** |

##### SP16 — `singer`, 30 cau — ~`58s`

- `output`: `output/nl2sql_single_prompt_singer_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 6 | 100.0 | 100.0 |
| Medium | 18 | 100.0 | 72.2 |
| Hard | 6 | 100.0 | 83.3 |
| Extra | 0 | — | — |
| **All** | **30** | **100.0** | **80.0** |

##### SP17 — `course_teach`, 30 cau — ~`57s`

- `output`: `output/nl2sql_single_prompt_course_teach_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 8 | 100.0 | 100.0 |
| Medium | 14 | 100.0 | 71.4 |
| Hard | 8 | 100.0 | 87.5 |
| Extra | 0 | — | — |
| **All** | **30** | **100.0** | **83.3** |

##### SP18 — `museum_visit`, 18 cau — ~`57s`

- `output`: `output/nl2sql_single_prompt_museum_visit_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 100.0 |
| Medium | 8 | 87.5 | 75.0 |
| Hard | 3 | 100.0 | 33.3 |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **18** | **88.9** | **55.6** |

##### SP19 — `battle_death`, 16 cau — ~`37s`

- `output`: `output/nl2sql_single_prompt_battle_death_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 100.0 |
| Medium | 8 | 87.5 | 62.5 |
| Hard | 1 | 100.0 | 100.0 |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **16** | **87.5** | **56.2** |

##### SP20 — `voter_1`, 15 cau — ~`38s`

- `output`: `output/nl2sql_single_prompt_voter_1_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 66.7 |
| Medium | 8 | 100.0 | 75.0 |
| Hard | 0 | — | — |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **15** | **93.3** | **53.3** |

#### Thu nghiem single-prompt: GPT-4o va DeepSeek-R1

Cac lan duoi day dung cung **`run_single_prompt_nl2sql.py`**; **`--tables`** bat buoc: `experiments/test-suite-sql-eval/tables.json`. **Khong** gop vao dong **Tong hop** SP2–SP20 (cac dong do chi **Gemini 2.5 Flash**).

| Run | Provider / model | `db_id` | So cau | EX (%) | EM (%) | Output |
| :-- | :-- | :-- | --: | --: | --: | :-- |
| GPT-4o `voter_1` | `openai` / `gpt-4o` | `voter_1` | 15 | **80.0** | **46.7** | `output/nl2sql_single_prompt_voter_1_gpt4o_full/` |
| GPT-4o `flight_2` | `openai` / `gpt-4o` | `flight_2` | 80 | **91.2** | **53.7** | `output/nl2sql_single_prompt_flight2_gpt4o_full/` |
| DeepSeek-R1 `voter_1` | `deepseek` / `deepseek-reasoner` | `voter_1` | 15 | **~93.3** | **~60.0** | `output/nl2sql_single_prompt_voter_1_deepseek_r1_full/` |

**GPT-4o** — lenh mau:

```bash
python run_single_prompt_nl2sql.py --provider openai --model gpt-4o \
  --db-id <db_id> \
  --tables experiments/test-suite-sql-eval/tables.json \
  --out-dir output/nl2sql_single_prompt_<db>_gpt4o_full --delay 0.15
```

**DeepSeek-R1** — can `DEEPSEEK_API_KEY`; script dung API tuong thich OpenAI (`https://api.deepseek.com`). Lenh mau:

```bash
python run_single_prompt_nl2sql.py --provider deepseek \
  --db-id voter_1 \
  --tables experiments/test-suite-sql-eval/tables.json \
  --out-dir output/nl2sql_single_prompt_voter_1_deepseek_r1_full --delay 0.5
```

**Luu y DeepSeek (`voter_1`):** mot cau (**Extra**, dong **14** trong `predict.sql`) sinh `CAST(SUBSTR(...))` **khong hop le** SQLite (thieu `AS ...`). Chay **`evaluation.py` tren du 15 dong** co the **treo CPU** lau o buoc so khop; nen **bo dong loi** hoac **sua SQL** truoc khi eval. Uoc luong **15 cau:** EX **~93,3%** (14/15 dung thuc thi), EM **~60,0%** (9/15); neu chi eval **14 cau** (bo dong loi): EX **100%**, EM **64,3%** tren subset do.

**Doi chieu nhanh:** GPT-4o tren **`flight_2`** co **cung EX** voi SP2 Gemini (**91,2%**); EM GPT-4o **53,7%** vs Gemini **57,5%**.

### Run 1 - Sonnet-heavy legacy mixed model

- `pipeline`: `6step`
- `db_id`: `music_1`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `anthropic/claude-sonnet-4-20250514`
- `Schema Selector`: `anthropic/claude-sonnet-4-20250514`
- `Query Planner`: `anthropic/claude-sonnet-4-20250514`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `anthropic/claude-sonnet-4-20250514`
- `SQL Validator`: `anthropic/claude-sonnet-4-20250514`
- `elapsed_time`: `1857.3s` (~`30.96` phut)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 5 | 100.0 | 80.0 |
| Medium | 16 | 75.0 | 37.5 |
| Hard | 23 | 73.9 | 21.7 |
| Extra | 6 | 66.7 | 0.0 |
| **All** | **50** | **76.0** | **30.0** |

Ghi chu nhanh:

- `EX` chua qua te tren subset `music_1`, nhung `EM` rat thap.
- `IUEN` trong partial matching bang `0.0`, cho thay cau hinh hien tai xu ly rat kem cac mau `INTERSECT / UNION / EXCEPT`.
- Hanh vi loi nghieng ve "SQL tuong duong thuc thi nhung khong canonic theo Spider", dan den mat `EM`.

### Next recommended run

Muc tieu cua vong ke tiep theo la tang `EM` bang cach dong bo cac step "ra quyet dinh cau truc SQL" ve `GPT-4o`, thay vi de `Sonnet 4` xu ly qua nhieu step semantic.

- `Schema Selector`: `anthropic/claude-sonnet-4-20250514`
- `Question Analyzer`: `openai/gpt-4o`
- `Query Planner`: `openai/gpt-4o`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `openai/gpt-4o`
- `SQL Validator`: `openai/gpt-4o`

Lenh chay:

```bash
python run_complete_nl2sql_pipeline.py --pipeline 6step --db_id music_1 --num_questions 50 --seed 42
```

### Run 2 - `GPT-4o-heavy` mixed model

- `pipeline`: `6step`
- `db_id`: `music_1`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `openai/gpt-4o`
- `Schema Selector`: `anthropic/claude-sonnet-4-20250514`
- `Query Planner`: `openai/gpt-4o`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `openai/gpt-4o`
- `SQL Validator`: `openai/gpt-4o`
- `elapsed_time`: `977.4s` (~`16.29` phut)

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 5 | 100.0 | 80.0 |
| Medium | 16 | 81.2 | 75.0 |
| Hard | 23 | 73.9 | 34.8 |
| Extra | 6 | 16.7 | 0.0 |
| **All** | **50** | **72.0** | **48.0** |

So voi `Run 1`:

- `EX`: `76.0 -> 72.0` (`-4.0`)
- `EM`: `30.0 -> 48.0` (`+18.0`)
- `Thoi gian`: `1857.3s -> 977.4s`

Nhan xet:

- Cau hinh nay tang `EM` rat manh, dung huong cho bai bao neu ban can SQL gan hon voi canonical Spider.
- `EX` giam nhe, chu yeu do cac cau `Extra` rot manh.
- `IUEN` van bang `0.0`, nghia la mau `INTERSECT / UNION / EXCEPT` van la diem nghẽn lon nhat.

### Run 3 - `B6` current best mixed-model 6-step

- `pipeline`: `6step`
- `db_id`: `flight_2`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `openai/gpt-4o`
- `Schema Selector`: `gemini/gemini-2.5-flash`
- `Query Planner`: `openai/gpt-4o`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `openai/gpt-4o`
- `SQL Validator`: `gemini/gemini-2.5-flash`
- `status`: `locked as current best mixed-model 6-step subset result`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 18 | 100.0 | 100.0 |
| Medium | 19 | 89.5 | 73.7 |
| Hard | 4 | 100.0 | 25.0 |
| Extra | 9 | 88.9 | 77.8 |
| **All** | **50** | **94.0** | **80.0** |

Nhan xet:

- Day la cau hinh mixed-model 6-step tot nhat hien da duoc ghi nhan tren subset co dinh `flight_2` (`seed = 42`).
- Khoang cach `EX - EM = 14` diem phan tram cho thay mot phan dang ke loi con lai la sai khac canonical-form, khong phai sai nghia truy van.
- `IUEN = 1.0` tren subset nay, nghia la set-operation khong con la diem nghẽn chinh trong dot chay hien tai.

Tom tat 10 truong hop non-EM de dua vao bang loi / discussion:

- `4/10` loi thuoc nhom entity-linking / FK-ID mapping: nham gia tri nhan voi khoa ngoai, hoac map sai `city` sang `airport code`.
- `5/10` loi thuoc nhom canonical but execution-preserving rewrites: `LEFT JOIN ... IS NULL` thay `NOT IN`, `IN` thay `OR`, `COUNT(col)` thay `COUNT(*)`, hoac bien the `GROUP BY`/`ORDER BY` van cho ket qua tuong duong.
- `1/10` loi projection / aggregation artifact: sinh `SELECT T1.count` thay vi `COUNT(*)`.

Mau loi dai dien:

- Airline-name vs `uid`: `WHERE flights.Airline = "JetBlue Airways"` thay vi join qua bang `airlines`.
- City vs code confusion: `WHERE DestAirport = "Aberdeen"` thay vi join `airports` va loc `City = "Aberdeen"`.
- Canonical anti-join rewrite: `LEFT JOIN ... WHERE FlightNo IS NULL` thay cho `NOT IN (SELECT ... UNION SELECT ...)`.

### Run 4 - `B3` 4-step baseline on the same fixed subset

- `pipeline`: `4step`
- `db_id`: `flight_2`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `anthropic/claude-sonnet-4-20250514`
- `Schema Selector`: `gemini/gemini-2.5-flash`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Validator`: `gemini/gemini-2.5-flash`
- `status`: `locked 4-step baseline for fair comparison with Run 3`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 19 | 100.0 | 73.7 |
| Medium | 18 | 77.8 | 50.0 |
| Hard | 6 | 83.3 | 16.7 |
| Extra | 7 | 71.4 | 14.3 |
| **All** | **50** | **86.0** | **50.0** |

So voi `Run 3`:

- `EX`: `86.0 -> 94.0` (`+8.0` cho 6-step)
- `EM`: `50.0 -> 80.0` (`+30.0` cho 6-step)
- `IUEN`: `0.0 -> 1.0`

Nhan xet:

- Day la bang doi chieu kien truc ro nhat hien co tren cung subset `flight_2`.
- `4-step` van giu duoc `EX` kha o nhom de, nhung rot manh o `EM`, dac biet voi `Hard/Extra`.
- Khoang cach `+30 EM` ung ho lap luan rang `Planner` va `Refiner` giup SQL tien gan canonical Spider hon, khong chi tang kha nang thuc thi.
- `IUEN = 0.0` cho thay `4-step` van xu ly rat yeu cac mau set-operation; day la diem khac biet quan trong so voi `Run 3`.

### Run 5 - `B4` 5-step without Planner on the same fixed subset

- `pipeline`: `6step ablation (skip Planner)`
- `db_id`: `flight_2`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `openai/gpt-4o`
- `Schema Selector`: `gemini/gemini-2.5-flash`
- `Query Planner`: `skipped`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `openai/gpt-4o`
- `SQL Validator`: `gemini/gemini-2.5-flash`
- `elapsed_time`: `1649.9s` (~`27.50` phut)
- `status`: `locked 5-step no-planner ablation for fair comparison with Run 3`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 19 | 100.0 | 94.7 |
| Medium | 18 | 88.9 | 66.7 |
| Hard | 6 | 100.0 | 66.7 |
| Extra | 7 | 71.4 | 28.6 |
| **All** | **50** | **92.0** | **72.0** |

So voi `Run 3`:

- `EX`: `92.0 -> 94.0` (`+2.0` cho 6-step day du)
- `EM`: `72.0 -> 80.0` (`+8.0` cho 6-step day du)
- `IUEN`: `1.0 -> 1.0`

So voi `Run 4`:

- `EX`: `86.0 -> 92.0` (`+6.0`)
- `EM`: `50.0 -> 72.0` (`+22.0`)

Nhan xet:

- Bo `Planner` khong lam he thong sup do; `EX` van rat cao (`92.0`), cho thay chuoi `Analyzer -> Generator -> Refiner -> Validator` da du kha nang giai quyet nhieu cau hoi tren subset nay.
- Tuy nhien, khoang cach `EM 72.0 -> 80.0` cho thay `Planner` van dong gop ro vao viec dinh hinh cau truc SQL gan hon voi canonical Spider.
- Tac dong cua `Planner` ro nhat nam o nhom `Extra`, noi `EM` chi dat `28.6`, thap hon nhieu so voi `Run 3` (`77.8`).
- `IUEN = 1.0` cho thay khi cac mau set-operation da duoc nhan dung, viec bo `Planner` khong xoa bo hoan toan nang luc nay, nhung van lam giam do on dinh tong the.

### Run 6 - `B5` 5-step without Refiner on the same fixed subset

- `pipeline`: `6step ablation (skip Refiner)`
- `db_id`: `flight_2`
- `num_questions`: `50`
- `seed`: `42`
- `Analyzer`: `openai/gpt-4o`
- `Schema Selector`: `gemini/gemini-2.5-flash`
- `Query Planner`: `openai/gpt-4o`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `skipped`
- `SQL Validator`: `gemini/gemini-2.5-flash`
- `elapsed_time`: `1869.2s` (~`31.15` phut)
- `status`: `locked 5-step no-refiner ablation for fair comparison with Run 3`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 19 | 100.0 | 100.0 |
| Medium | 18 | 88.9 | 66.7 |
| Hard | 6 | 83.3 | 33.3 |
| Extra | 7 | 71.4 | 42.9 |
| **All** | **50** | **90.0** | **72.0** |

So voi `Run 3`:

- `EX`: `90.0 -> 94.0` (`+4.0` cho 6-step day du)
- `EM`: `72.0 -> 80.0` (`+8.0` cho 6-step day du)
- `IUEN`: `1.0 -> 1.0`

So voi `Run 5`:

- `EX`: `92.0 -> 90.0` (`-2.0` khi bo Refiner thay vi bo Planner)
- `EM`: `72.0 -> 72.0` (`0.0`)

So voi `Run 4`:

- `EX`: `86.0 -> 90.0` (`+4.0`)
- `EM`: `50.0 -> 72.0` (`+22.0`)

Nhan xet:

- Tren subset nay, bo `Refiner` lam `EX` giam nhieu hon bo `Planner` (`90.0` so voi `92.0`), trong khi `EM` cua hai bien the 5-step bang nhau (`72.0`).
- Dieu nay goi y `Refiner` dong vai tro quan trong hon doi voi do on dinh thuc thi, con `Planner` dong vai tro ro hon trong viec day SQL ve dang canonical o cac cau kho / extra.
- Nhom `Hard` va `Extra` van la noi mat mat lon nhat khi bo `Refiner`, nhung ton that nhe hon baseline 4-step rat ro.

### Ablation takeaway

Thu tu ket qua tong the tren cung subset `flight_2 / 50 / seed 42`:

- `Run 3` - full `6-step`: `EX 94.0`, `EM 80.0`
- `Run 5` - `5-step without Planner`: `EX 92.0`, `EM 72.0`
- `Run 6` - `5-step without Refiner`: `EX 90.0`, `EM 72.0`
- `Run 4` - `4-step baseline`: `EX 86.0`, `EM 50.0`

Tom tat dien giai:

- Them ca `Planner` va `Refiner` deu mang lai loi ich ro rang so voi `4-step`.
- `Planner` va `Refiner` deu gop `+22 EM` so voi `4-step` khi moi bo mot trong hai step.
- `Refiner` co ve quan trong hon cho `EX` tren subset nay (`90.0` khi bo Refiner vs `92.0` khi bo Planner).
- `Planner` co ve quan trong hon cho do on dinh cau truc o nhom phuc tap, dac biet khi doi chieu voi `Run 3` day du.

### Next recommended run

Muc tieu ablation tren subset co dinh da hoan tat.

- Ban da co du bo `4-step / no_planner / no_refiner / 6-step` tren cung `flight_2`, `50` cau, `seed = 42`.
- Buoc tiep theo hop ly nhat khong phai la them mot ablation nua, ma la dua cac so nay vao bang ablation va phan discussion trong bai bao.
- Neu van muon chay them benchmark, uu tien tiep theo nen la lap lai bo 4 run nay tren mot database khac co >50 cau hoi de kiem tra do on dinh cua xu huong.

### Legacy next recommended run after Run 2

Muc tieu cua vong tiep theo la giu lai `EM` vua cai thien, nhung cuu `EX` cho cac cau kho bang cach dua `Planner` va `Refiner` sang model reasoning manh hon cho cac pattern set-operation.

- `Schema Selector`: `anthropic/claude-sonnet-4-20250514`
- `Question Analyzer`: `openai/gpt-4o`
- `Query Planner`: `deepseek/deepseek-reasoner`
- `SQL Generator`: `openai/gpt-4o`
- `SQL Refiner`: `deepseek/deepseek-reasoner`
- `SQL Validator`: `openai/gpt-4o`

Ky vong:

- Neu `DeepSeek-R1` that su manh o set-operation planning, `EX` co the hoi phuc o nhom `Hard/Extra`.
- `EM` co the giam nhe so voi `Run 2`, nhung neu khong giam qua sau thi day la ung vien can bang tot hon.

Cap nhat trang thai:

- Sau cac lan chay tiep theo, `Run 3` duoc chon lam moc `mixed-model 6-step tot nhat` cho subset `flight_2` 50 cau.
- Khong nen tron truc tiep so lieu subset nay vao cac bang main-result full-dev trong paper; thay vao do, dung no cho bang benchmark noi bo, bang loi mau, va phan discussion ve residual errors.

## Tong quan baseline **Single-agent** (mot goi LLM / mot cau hoi)

**Pham vi bang duoi day:** chi cac lan **`run_single_prompt_nl2sql.py`** voi **Gemini 2.5 Flash** — he thong **mot tac nhan** (khong CrewAI, khong pipeline nhieu buoc). Muc tieu la **cai nhin tong quat** ve chat luong single-prompt theo tung `db_id` tren Spider dev. Cac lan **GPT-4o** / **DeepSeek-R1** (single-prompt) nam o muc **Thu nghiem single-prompt: GPT-4o va DeepSeek-R1** phia tren. So lieu pipeline da tac nhan (`Run 1`–`Run 6`, v.v.) nam o cac muc **Run** trong file, **khong** gop vao bang nay.

| ID | `db_id` | So cau | EX (%) | EM (%) | Ghi chu |
| :-- | :-- | --: | --: | --: | :-- |
| `SP2` | `flight_2` | 80 | 91.2 | 57.5 | Full cau hoi dev cho DB |
| `SP3` | `world_1` | 120 | 82.5 | 46.7 | Full dev DB |
| `SP4` | `car_1` | 92 | 71.7 | 22.8 | Full dev DB |
| `SP5` | `cre_Doc_Template_Mgt` | 84 | 91.7 | 39.3 | Full dev DB |
| `SP6` | `dog_kennels` | 82 | 79.3 | 35.4 | Full dev DB |
| `SP7` | `student_transcripts_tracking` | 78 | 71.8 | 39.7 | Full dev DB |
| `SP8` | `wta_1` | 62 | 83.9 | 51.6 | Full dev DB |
| `SP9` | `tvshow` | 62 | 88.7 | 64.5 | Full dev DB |
| `SP10` | `network_1` | 56 | 75.0 | 35.7 | Full dev DB |
| `SP11` | `concert_singer` | 45 | 97.8 | 64.4 | Full dev DB |
| `SP12` | `pets_1` | 42 | 95.2 | 42.9 | Full dev DB |
| `SP13` | `poker_player` | 40 | 100.0 | 75.0 | Full dev DB |
| `SP14` | `orchestra` | 40 | 97.5 | 65.0 | Full dev DB |
| `SP15` | `employee_hire_evaluation` | 38 | 100.0 | 68.4 | Full dev DB |
| `SP16` | `singer` | 30 | 100.0 | 80.0 | Full dev DB |
| `SP17` | `course_teach` | 30 | 100.0 | 83.3 | Full dev DB |
| `SP18` | `museum_visit` | 18 | 88.9 | 55.6 | Full dev DB |
| `SP19` | `battle_death` | 16 | 87.5 | 56.2 | Full dev DB |
| `SP20` | `voter_1` | 15 | 93.3 | 53.3 | Full dev DB |
| **Tong hop** | *(19 DB, trong so theo so cau)* | **1030** | **86.4** | **49.8** | Khong gom subset `flight_2` 50 / seed 42; khong gom `real_estate_properties` (4 cau) |

**Tom tat:** **19** `db_id`, **1030** cau-luot tren dev (con **4** cau `real_estate_properties` khong bao cao). Dong **Tong hop**: EX/EM **trong so** theo cot *So cau*.

*(Tuy chon: mot lan **1034** cau khong `--db-id` — hang `SP-full-dev` trong ke hoach — de co mot cap EX/EM tren toan dev.)*
