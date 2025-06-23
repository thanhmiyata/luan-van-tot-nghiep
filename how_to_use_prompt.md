# 📖 Hướng Dẫn Sử Dụng Dataset Generation Prompt

## 🎯 Mục đích
File `dataset_generation_prompt.md` chứa prompt chi tiết để generate dataset 1000 câu hỏi Text-to-SQL với các AI platform khác.

## 🤖 Các AI Platform Được Khuyến Nghị

### 1. **Claude (Anthropic)** ⭐⭐⭐⭐⭐
- **Ưu điểm**: Xuất sắc về logic và structured data
- **Cách dùng**: Copy toàn bộ prompt vào Claude
- **Tip**: Có thể chia nhỏ thành batch 200-300 câu hỏi

### 2. **ChatGPT (OpenAI)** ⭐⭐⭐⭐
- **Ưu điểm**: Tốt về ngôn ngữ tự nhiên
- **Cách dùng**: Dùng GPT-4 cho kết quả tốt nhất
- **Tip**: Có thể cần prompt thêm về format JSON

### 3. **Gemini (Google)** ⭐⭐⭐
- **Ưu điểm**: Hiểu context tốt
- **Cách dùng**: Upload prompt file trực tiếp
- **Tip**: Kiểm tra format output carefully

## 📋 Quy Trình Thực Hiện

### Bước 1: Preparation
```bash
# Copy nội dung file dataset_generation_prompt.md
cat dataset_generation_prompt.md
```

### Bước 2: Execute với AI
1. Mở AI platform của choice
2. Paste toàn bộ prompt
3. Chờ AI generate dataset
4. Kiểm tra format JSON output

### Bước 3: Validation
- ✅ Đúng 1000 câu hỏi
- ✅ Phân bố level đúng (300-250-200-150-100)
- ✅ 50-50 Vietnamese-English
- ✅ Valid JSON format
- ✅ SQL syntax check

### Bước 4: Save Output
```bash
# Lưu output thành file JSON
echo "Generated dataset" > dataset_1000_questions.json
```

## ⚠️ Lưu Ý Quan Trọng

1. **Batch Processing**: Nếu AI không thể generate 1000 câu cùng lúc, chia thành batches:
   - Batch 1: Level 1 (300 câu)
   - Batch 2: Level 2 (250 câu)
   - Batch 3: Level 3 (200 câu)
   - Batch 4: Level 4 (150 câu)
   - Batch 5: Level 5 (100 câu)

2. **Quality Check**: Luôn validate SQL queries trước khi sử dụng

3. **Format Consistency**: Đảm bảo JSON format đúng chuẩn

## 🔧 Troubleshooting

### Vấn đề: AI generates incomplete dataset
**Giải pháp**: Prompt lại với "Continue generating from question #X"

### Vấn đề: Invalid SQL syntax
**Giải pháp**: Review và correct manually hoặc re-prompt specific questions

### Vấn đề: Wrong language distribution
**Giải pháp**: Specify exactly "Generate X Vietnamese questions and Y English questions"

## ✅ Expected Output Structure
```json
[
  {
    "question_id": "Q001",
    "level": 1,
    "language": "vi",
    "domain": "basic_business",
    "question": "...",
    "sql_query": "...",
    "explanation": "...",
    "expected_result_type": "...",
    "complexity_features": [...],
    "business_context": "..."
  }
  // ... 999 more questions
]
```

---
**Good luck với dataset generation! 🚀** 