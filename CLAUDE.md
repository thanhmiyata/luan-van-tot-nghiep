# Project: Luận văn Tốt nghiệp - NL2SQL Agent

## Overview
Dự án nghiên cứu và phát triển hệ thống NL2SQL (Natural Language to SQL) đa tác nhân (Multi-Agent). Tập trung vào việc tối ưu hóa độ chính xác của câu truy vấn SQL thông qua quy trình pipeline gồm nhiều bước.

## Project Structure
- `src/`: Mã nguồn của hệ thống.
- `conference_paper_vn_22-25p.md`: File chính đang làm việc (bài báo hội nghị).
- `MEMORY.md`: Chứa trạng thái hiện tại và lịch sử làm việc.
- `.agent/skills/`: Các kỹ năng bổ trợ cho AI.

## Guidelines
- **Ngôn ngữ:** Tiếng Việt (học thuật) cho tài liệu, Tiếng Anh cho code/comments.
- **Vibe Coding:** Ưu tiên hiệu quả, súc tích, tránh giải thích thừa thãi.
- **Reference:** Xem `MEMORY.md` trước khi bắt đầu bất kỳ task mới nào để nắm bối cảnh.
- **Memory Update:** Sau mỗi task lớn, hãy cập nhật `MEMORY.md`.

## Essential Commands
- **Venv:** `source venv/bin/activate`
- **Run Pipeline:** `python run_complete_nl2sql_pipeline.py`
- **Test:** `pytest test/`
