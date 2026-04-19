# Báo cáo benchmark Single-agent (NL2SQL một prompt)

Tài liệu này tổng hợp **toàn bộ** các lượt chạy baseline **một tác nhân** (`run_single_prompt_nl2sql.py`, một lời gọi LLM cho mỗi câu hỏi) trên tập phát triển Spider 1.0, phục vụ trích dẫn trong luận văn / nghiên cứu. Pipeline đa tác nhân (CrewAI) **không** nằm trong file này.

---

## 1. Mục đích và phạm vi

| Mục | Mô tả |
| :-- | :-- |
| Đối tượng | Baseline **single-agent**: sinh SQL trực tiếp từ câu hỏi + lược đồ, không phân rã bước trung gian. |
| Model (đã chạy) | **Gemini 2.5 Flash** (bảng master SP2–SP20); thử nghiệm thêm **OpenAI GPT-4o** và **DeepSeek-R1** (`deepseek-reasoner`) — xem mục **7b**. |
| Chỉ số | **Exact Match (EM)** và **Execution Accuracy (EX)** theo script đánh giá Spider (`experiments/test-suite-sql-eval/evaluation.py`). |
| Phạm vi câu | Mỗi hàng trong bảng master là **toàn bộ câu hỏi dev** của một `db_id` (trừ các loại trừ ở mục 3). |

---

## 2. Giao thức tái lập

- **Script chạy:** `run_single_prompt_nl2sql.py`  
- **Provider / model:**  
  - Gemini: `--provider gemini --model gemini-2.5-flash`  
  - GPT-4o: `--provider openai --model gpt-4o` (biến môi trường `OPENAI_API_KEY`)  
  - DeepSeek-R1: `--provider deepseek` (mặc định `deepseek-reasoner`; `DEEPSEEK_API_KEY`; API `https://api.deepseek.com`)  
- **Bắt buộc khi chạy trong repo này:** `--tables experiments/test-suite-sql-eval/tables.json` (không dùng đường dẫn `data/tables.json` mặc định nếu file không tồn tại).  
- **Tham số điển hình:** `--db-id <db_id> --out-dir <thư_mục_output>` (full câu trong dev cho `db_id` đó).  
- **Temperature:** 0 (theo thực hành dự án).  
- **Đánh giá** (từ thư mục gốc repo, sau khi có `gold.sql` / `predict.sql`):

```bash
python experiments/test-suite-sql-eval/evaluation.py \
  --gold <out_dir>/gold.sql \
  --pred <out_dir>/predict.sql \
  --db experiments/test-suite-sql-eval/database \
  --etype all \
  --table experiments/test-suite-sql-eval/tables.json \
  --plug_value
```

- **File câu hỏi tham chiếu:** `output/questions_dev.json` — **1034** câu trên toàn Spider dev, nhiều `db_id`.

---

## 3. Loại trừ khỏi tổng hợp chính

| Loại trừ | Lý do |
| :-- | :-- |
| Subset **`flight_2`**, **50 câu**, **`seed = 42`** (ký hiệu log cũ **SP1**) | Trùng ngữ cảnh với các run pipeline trên cùng subset/seed; **không** tính vào dòng tổng hợp. |
| **`real_estate_properties`** | Chỉ **4** câu trong dev — mẫu quá nhỏ, không báo cáo benchmark có ý nghĩa thống kê. |

**Lưu ý:** **`flight_2` full 80 câu (SP2)** **có** được tính trong tổng hợp — đây là full dev cho DB đó, khác subset 50/seed 42.

---

## 4. Cách tính tổng hợp (trung bình theo **câu** — micro-average)

Với mỗi database \(i\): \(n_i\) câu, \(\mathrm{EX}_i\%\), \(\mathrm{EM}_i\%\) lấy từ kết quả đánh giá **trên đúng \(n_i\) câu** đó.

\[
\mathrm{EX}_{\mathrm{tổng}} = \frac{\sum_i n_i \cdot \mathrm{EX}_i / 100}{\sum_i n_i} \times 100
= \frac{\text{tổng số câu EX đúng}}{\text{tổng số câu}}
\]

(công thức tương tự cho EM.)

Đây là **một phiếu một câu** trên toàn các câu đã gộp (**không** phải trung bình cộng 19 phần trăm theo DB).

---

## 5. Bảng master — tất cả lượt đã báo cáo (SP2–SP20)

| ID | `db_id` | Số câu | EX (%) | EM (%) | Thư mục output (relative) |
| :-- | :-- | --: | --: | --: | :-- |
| SP2 | `flight_2` | 80 | 91.2 | 57.5 | `output/nl2sql_single_prompt_flight2_gemini25_full/` |
| SP3 | `world_1` | 120 | 82.5 | 46.7 | `output/nl2sql_single_prompt_world1_gemini25_full/` |
| SP4 | `car_1` | 92 | 71.7 | 22.8 | `output/nl2sql_single_prompt_car1_gemini25_full/` |
| SP5 | `cre_Doc_Template_Mgt` | 84 | 91.7 | 39.3 | `output/nl2sql_single_prompt_cre_Doc_Template_Mgt_gemini25_full/` |
| SP6 | `dog_kennels` | 82 | 79.3 | 35.4 | `output/nl2sql_single_prompt_dog_kennels_gemini25_full/` |
| SP7 | `student_transcripts_tracking` | 78 | 71.8 | 39.7 | `output/nl2sql_single_prompt_student_transcripts_tracking_gemini25_full/` |
| SP8 | `wta_1` | 62 | 83.9 | 51.6 | `output/nl2sql_single_prompt_wta_1_gemini25_full/` |
| SP9 | `tvshow` | 62 | 88.7 | 64.5 | `output/nl2sql_single_prompt_tvshow_gemini25_full/` |
| SP10 | `network_1` | 56 | 75.0 | 35.7 | `output/nl2sql_single_prompt_network_1_gemini25_full/` |
| SP11 | `concert_singer` | 45 | 97.8 | 64.4 | `output/nl2sql_single_prompt_concert_singer_gemini25_full/` |
| SP12 | `pets_1` | 42 | 95.2 | 42.9 | `output/nl2sql_single_prompt_pets_1_gemini25_full/` |
| SP13 | `poker_player` | 40 | 100.0 | 75.0 | `output/nl2sql_single_prompt_poker_player_gemini25_full/` |
| SP14 | `orchestra` | 40 | 97.5 | 65.0 | `output/nl2sql_single_prompt_orchestra_gemini25_full/` |
| SP15 | `employee_hire_evaluation` | 38 | 100.0 | 68.4 | `output/nl2sql_single_prompt_employee_hire_evaluation_gemini25_full/` |
| SP16 | `singer` | 30 | 100.0 | 80.0 | `output/nl2sql_single_prompt_singer_gemini25_full/` |
| SP17 | `course_teach` | 30 | 100.0 | 83.3 | `output/nl2sql_single_prompt_course_teach_gemini25_full/` |
| SP18 | `museum_visit` | 18 | 88.9 | 55.6 | `output/nl2sql_single_prompt_museum_visit_gemini25_full/` |
| SP19 | `battle_death` | 16 | 87.5 | 56.2 | `output/nl2sql_single_prompt_battle_death_gemini25_full/` |
| SP20 | `voter_1` | 15 | 93.3 | 53.3 | `output/nl2sql_single_prompt_voter_1_gemini25_full/` |

---

## 6. Tổng hợp (micro-average trên các câu đã gộp)

| Chỉ số | Giá trị | Ghi chú |
| :-- | --: | :-- |
| Tổng số câu \(\sum_i n_i\) | **1030** | Trên **19** `db_id`; thiếu **4** câu `real_estate_properties` so với 1034 nếu tính đủ mọi DB trong dev. |
| **EX** (micro) | **86,4%** | Làm tròn một chữ số thập phân; giá trị mịn ~86,41%. |
| **EM** (micro) | **49,8%** | Làm tròn một chữ số thập phân; giá trị mịn ~49,80%. |

**Công thức:** như mục 4; tương đương \(\sum_i (n_i \times \mathrm{EX}_i\%) / 1030\) với phần trăm ở dạng số thực.

---

## 7. Chi tiết theo từng lượt chạy (phân rã độ khó Spider)

Dưới đây là cấu hình tối thiểu và bảng **Split** (Easy / Medium / Hard / Extra / All) cho từng ID. Thời gian chạy (wall) ghi trong log thực nghiệm; một số mục có ước lượng trong bản log nội bộ (`benchmark_matrix_mixed_model.md`).

### SP2 — `flight_2`, full 80 câu

- `script`: `run_single_prompt_nl2sql.py`  
- `provider` / `model`: `gemini` / `gemini-2.5-flash`  
- `db_id`: `flight_2`  
- `num_questions`: `80` (full dev)  
- `output`: `output/nl2sql_single_prompt_flight2_gemini25_full/`

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 26 | 100.0 | 100.0 |
| Medium | 30 | 100.0 | 53.3 |
| Hard | 8 | 87.5 | 25.0 |
| Extra | 16 | 62.5 | 12.5 |
| **All** | **80** | **91.2** | **57.5** |

### SP3 — `world_1`, full 120 câu

- `output`: `output/nl2sql_single_prompt_world1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~267 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 24 | 100.0 | 83.3 |
| Medium | 46 | 91.3 | 60.9 |
| Hard | 20 | 75.0 | 30.0 |
| Extra | 30 | 60.0 | 6.7 |
| **All** | **120** | **82.5** | **46.7** |

### SP4 — `car_1`, full 92 câu

- `output`: `output/nl2sql_single_prompt_car1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~269 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 18 | 94.4 | 61.1 |
| Medium | 32 | 68.8 | 25.0 |
| Hard | 16 | 62.5 | 0.0 |
| Extra | 26 | 65.4 | 7.7 |
| **All** | **92** | **71.7** | **22.8** |

### SP5 — `cre_Doc_Template_Mgt`, full 84 câu

- `output`: `output/nl2sql_single_prompt_cre_Doc_Template_Mgt_gemini25_full/`  
- `elapsed_time` (tham khảo): ~177 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 24 | 95.8 | 79.2 |
| Medium | 44 | 88.6 | 27.3 |
| Hard | 10 | 100.0 | 20.0 |
| Extra | 6 | 83.3 | 0.0 |
| **All** | **84** | **91.7** | **39.3** |

### SP6 — `dog_kennels`, full 82 câu

- `output`: `output/nl2sql_single_prompt_dog_kennels_gemini25_full/`  
- `elapsed_time` (tham khảo): ~206 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 10 | 100.0 | 100.0 |
| Medium | 36 | 88.9 | 44.4 |
| Hard | 10 | 60.0 | 30.0 |
| Extra | 26 | 65.4 | 0.0 |
| **All** | **82** | **79.3** | **35.4** |

### SP7 — `student_transcripts_tracking`, full 78 câu

- `output`: `output/nl2sql_single_prompt_student_transcripts_tracking_gemini25_full/`  
- `elapsed_time` (tham khảo): ~201 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 26 | 84.6 | 61.5 |
| Medium | 24 | 83.3 | 54.2 |
| Hard | 8 | 75.0 | 25.0 |
| Extra | 20 | 40.0 | 0.0 |
| **All** | **78** | **71.8** | **39.7** |

### SP8 — `wta_1`, full 62 câu

- `output`: `output/nl2sql_single_prompt_wta_1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~134 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 16 | 93.8 | 56.2 |
| Medium | 30 | 86.7 | 66.7 |
| Hard | 14 | 64.3 | 14.3 |
| Extra | 2 | 100.0 | 50.0 |
| **All** | **62** | **83.9** | **51.6** |

### SP9 — `tvshow`, full 62 câu

- `output`: `output/nl2sql_single_prompt_tvshow_gemini25_full/`  
- `elapsed_time` (tham khảo): ~127 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 20 | 90.0 | 85.0 |
| Medium | 30 | 96.7 | 60.0 |
| Hard | 10 | 80.0 | 50.0 |
| Extra | 2 | 0.0 | 0.0 |
| **All** | **62** | **88.7** | **64.5** |

### SP10 — `network_1`, full 56 câu

- `output`: `output/nl2sql_single_prompt_network_1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~144 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 12 | 91.7 | 83.3 |
| Medium | 22 | 72.7 | 18.2 |
| Hard | 16 | 68.8 | 37.5 |
| Extra | 6 | 66.7 | 0.0 |
| **All** | **56** | **75.0** | **35.7** |

### SP11 — `concert_singer`, full 45 câu

- `output`: `output/nl2sql_single_prompt_concert_singer_gemini25_full/`  
- `elapsed_time` (tham khảo): ~90 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 4 | 100.0 | 100.0 |
| Medium | 24 | 95.8 | 66.7 |
| Hard | 13 | 100.0 | 61.5 |
| Extra | 4 | 100.0 | 25.0 |
| **All** | **45** | **97.8** | **64.4** |

### SP12 — `pets_1`, full 42 câu

- `output`: `output/nl2sql_single_prompt_pets_1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~100 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 4 | 100.0 | 100.0 |
| Medium | 22 | 95.5 | 50.0 |
| Hard | 6 | 100.0 | 0.0 |
| Extra | 10 | 90.0 | 30.0 |
| **All** | **42** | **95.2** | **42.9** |

### SP13 — `poker_player`, full 40 câu

- `output`: `output/nl2sql_single_prompt_poker_player_gemini25_full/`  
- `elapsed_time` (tham khảo): ~75 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 16 | 100.0 | 100.0 |
| Medium | 16 | 100.0 | 81.2 |
| Hard | 8 | 100.0 | 12.5 |
| Extra | 0 | — | — |
| **All** | **40** | **100.0** | **75.0** |

### SP14 — `orchestra`, full 40 câu

- `output`: `output/nl2sql_single_prompt_orchestra_gemini25_full/`  
- `elapsed_time` (tham khảo): ~76 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 14 | 100.0 | 100.0 |
| Medium | 18 | 94.4 | 55.6 |
| Hard | 6 | 100.0 | 33.3 |
| Extra | 2 | 100.0 | 0.0 |
| **All** | **40** | **97.5** | **65.0** |

### SP15 — `employee_hire_evaluation`, 38 câu

- `output`: `output/nl2sql_single_prompt_employee_hire_evaluation_gemini25_full/`  
- `elapsed_time` (tham khảo): ~74 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 10 | 100.0 | 100.0 |
| Medium | 14 | 100.0 | 71.4 |
| Hard | 10 | 100.0 | 60.0 |
| Extra | 4 | 100.0 | 0.0 |
| **All** | **38** | **100.0** | **68.4** |

### SP16 — `singer`, 30 câu

- `output`: `output/nl2sql_single_prompt_singer_gemini25_full/`  
- `elapsed_time` (tham khảo): ~58 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 6 | 100.0 | 100.0 |
| Medium | 18 | 100.0 | 72.2 |
| Hard | 6 | 100.0 | 83.3 |
| Extra | 0 | — | — |
| **All** | **30** | **100.0** | **80.0** |

### SP17 — `course_teach`, 30 câu

- `output`: `output/nl2sql_single_prompt_course_teach_gemini25_full/`  
- `elapsed_time` (tham khảo): ~57 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 8 | 100.0 | 100.0 |
| Medium | 14 | 100.0 | 71.4 |
| Hard | 8 | 100.0 | 87.5 |
| Extra | 0 | — | — |
| **All** | **30** | **100.0** | **83.3** |

### SP18 — `museum_visit`, 18 câu

- `output`: `output/nl2sql_single_prompt_museum_visit_gemini25_full/`  
- `elapsed_time` (tham khảo): ~57 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 100.0 |
| Medium | 8 | 87.5 | 75.0 |
| Hard | 3 | 100.0 | 33.3 |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **18** | **88.9** | **55.6** |

### SP19 — `battle_death`, 16 câu

- `output`: `output/nl2sql_single_prompt_battle_death_gemini25_full/`  
- `elapsed_time` (tham khảo): ~37 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 100.0 |
| Medium | 8 | 87.5 | 62.5 |
| Hard | 1 | 100.0 | 100.0 |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **16** | **87.5** | **56.2** |

### SP20 — `voter_1`, 15 câu

- `output`: `output/nl2sql_single_prompt_voter_1_gemini25_full/`  
- `elapsed_time` (tham khảo): ~38 s

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 100.0 | 66.7 |
| Medium | 8 | 100.0 | 75.0 |
| Hard | 0 | — | — |
| Extra | 4 | 75.0 | 0.0 |
| **All** | **15** | **93.3** | **53.3** |

---

## 7b. Các lượt chạy OpenAI (GPT-4o) và DeepSeek-R1

Các lượt dưới đây **không** gộp vào mục **6** (tổng hợp micro chỉ gồm **Gemini** trên 19 DB). Dùng cùng script đánh giá `evaluation.py` và cùng `tables.json` như mục 2.

### Bảng tổng hợp nhanh

| Run | Provider | Model | `db_id` | Số câu | EX (%) | EM (%) | Thư mục output |
| :-- | :-- | :-- | :-- | --: | --: | --: | :-- |
| GPT-4o — `voter_1` | `openai` | `gpt-4o` | `voter_1` | 15 | **80.0** | **46.7** | `output/nl2sql_single_prompt_voter_1_gpt4o_full/` |
| GPT-4o — `flight_2` | `openai` | `gpt-4o` | `flight_2` | 80 | **91.2** | **53.7** | `output/nl2sql_single_prompt_flight2_gpt4o_full/` |
| DeepSeek-R1 — `voter_1` | `deepseek` | `deepseek-reasoner` | `voter_1` | 15 | **~93.3** | **~60.0** | `output/nl2sql_single_prompt_voter_1_deepseek_r1_full/` |

**Đối chiếu Gemini cùng DB:** SP2 `flight_2` (Gemini) EX **91.2%**, EM **57.5%** — GPT-4o cùng EX, EM thấp hơn nhẹ. SP20 `voter_1` (Gemini) EX **93.3%**, EM **53.3%**.

### GPT-4o — `voter_1`, 15 câu

```bash
python run_single_prompt_nl2sql.py --provider openai --model gpt-4o \
  --db-id voter_1 \
  --tables experiments/test-suite-sql-eval/tables.json \
  --out-dir output/nl2sql_single_prompt_voter_1_gpt4o_full --delay 0.15
```

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 3 | 66.7 | 33.3 |
| Medium | 8 | 100.0 | 75.0 |
| Hard | 0 | — | — |
| Extra | 4 | 50.0 | 0.0 |
| **All** | **15** | **80.0** | **46.7** |

### GPT-4o — `flight_2`, 80 câu

```bash
python run_single_prompt_nl2sql.py --provider openai --model gpt-4o \
  --db-id flight_2 \
  --tables experiments/test-suite-sql-eval/tables.json \
  --out-dir output/nl2sql_single_prompt_flight2_gpt4o_full --delay 0.15
```

| Split | Count | EX (%) | EM (%) |
| :-- | --: | --: | --: |
| Easy | 26 | 100.0 | 96.2 |
| Medium | 30 | 100.0 | 50.0 |
| Hard | 8 | 100.0 | 37.5 |
| Extra | 16 | 56.2 | 0.0 |
| **All** | **80** | **91.2** | **53.7** |

### DeepSeek-R1 — `voter_1`, 15 câu

```bash
python run_single_prompt_nl2sql.py --provider deepseek \
  --db-id voter_1 \
  --tables experiments/test-suite-sql-eval/tables.json \
  --out-dir output/nl2sql_single_prompt_voter_1_deepseek_r1_full --delay 0.5
```

- **API:** `DEEPSEEK_API_KEY`; client OpenAI-compatible (`https://api.deepseek.com`); mặc định `max_tokens` lớn hơn cho reasoning (xem `run_single_prompt_nl2sql.py`).
- **Vấn đề câu 14 (Extra):** một dòng trong `predict.sql` sinh `CAST(SUBSTR(...))` **không hợp lệ** SQLite (thiếu `AS …`). Chạy `evaluation.py` trên **đủ 15 dòng** có thể **kẹt CPU** lâu ở bước so khớp kết quả; nên **bỏ/sửa** dòng lỗi trước khi eval toàn bộ.
- **Ước lượng trên 15 câu (coi câu 14 là sai EX và sai EM):** EX **~93,3%** (14/15), EM **~60,0%** (9/15).
- **Đánh giá 14 câu (bỏ dòng 14 trong gold/pred):** EX **100%**, EM **64,3%** trên subset đó (để đối chiếu nội bộ, không thay thế báo cáo 15 câu đầy đủ cho đến khi sửa SQL).

---

## 8. Tùy chọn chưa bắt buộc

- **Một lượt full 1034 câu** không `--db-id` (kế hoạch `SP-full-dev`): xem lệnh mẫu trong `report/benchmark_matrix_mixed_model.md` — dùng khi cần **một** cặp EX/EM trên toàn dev trong **một** lần chạy liên tục.  
- **Trung bình theo DB (macro):** nếu cần báo cáo thêm (mỗi database một trọng số bằng nhau), tính riêng; **không** thay thế micro-average trong mục 6 khi so sánh với “tỷ lệ đúng trên N câu”.

---

## 9. Ghi chú dùng trong nghiên cứu

- Tổng hợp mục 6 là **micro-average** trên **1030** câu đã chạy đủ theo DB; **không** tự động tương đương một lượt đánh giá **1034** câu trong một file `gold`/`pred` duy nhất (trừ khi thực hiện tùy chọn mục 8).  
- So sánh với pipeline đa tác nhân trong bài báo cần **cùng giao thức đánh giá và cùng tập câu**; các số full-dev pipeline nằm trong `report/conference-ready-12_vi.md`, không trộn trực tiếp với bảng này mà không giải thích phạm vi.  
- Bản log mở rộng (nhận xét từng DB, benchmark matrix đầy đủ): `report/benchmark_matrix_mixed_model.md`. Các lượt **GPT-4o** / **DeepSeek-R1** cũng được ghi trong file đó (mục **Thu nghiem single-prompt: GPT-4o va DeepSeek-R1**).

---

*Bản cập nhật: đồng bộ với bảng tổng hợp single-agent và thử nghiệm GPT-4o / DeepSeek trong `report/benchmark_matrix_mixed_model.md`.*
