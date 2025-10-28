# Multi-Agent SQL System - Setup Guide

Hướng dẫn chi tiết để setup và chạy hệ thống Multi-Agent SQL.

## 📋 Yêu cầu hệ thống

- **Python**: 3.10 hoặc cao hơn
- **RAM**: Tối thiểu 4GB
- **Disk**: ~500MB cho dependencies + ~100MB cho data
- **Internet**: Cần kết nối để gọi API (Google Gemini)

## 🚀 Hướng dẫn Setup

### Bước 1: Kích hoạt Virtual Environment

```powershell
# Windows PowerShell (từ thư mục gốc dự án)
cd "d:\KrizPham\2. Work\1.Luan-van\luan-van-tot-nghiep"
.\venv\Scripts\activate

# Chuyển vào thư mục multi-agent-sql
cd multi-agent-sql
```

### Bước 2: Cài đặt Dependencies

```powershell
# Cài đặt các package cần thiết
pip install -r requirements.txt
```

**Dependencies chính:**
- `pydantic` - Data validation
- `google-generativeai` - Gemini API
- `python-dotenv` - Environment variables
- `PyYAML` - Config files
- `loguru` - Logging
- `click` - CLI tool
- `pandas`, `numpy` - Data processing
- `sqlparse` - SQL parsing

### Bước 3: Cấu hình Environment Variables

1. **Copy file template:**
```powershell
Copy-Item env.example .env
```

2. **Chỉnh sửa file `.env`:**
```powershell
notepad .env
```

3. **Thêm API key của bạn:**
```env
# Bắt buộc - Google Gemini API Key
GEMINI_API_KEY=your_actual_api_key_here
GOOGLE_API_KEY=your_actual_api_key_here

# Tùy chọn - Các API khác
OPENAI_API_KEY=your_openai_key_here
```

**Lấy Gemini API Key:**
1. Truy cập: https://makersuite.google.com/app/apikey
2. Đăng nhập với Google account
3. Tạo API key mới
4. Copy và paste vào file `.env`

### Bước 4: Setup Data

**Option 1: Tự động (Khuyên dùng)**
```powershell
python setup_data.py
```

Script này sẽ:
- Tạo các thư mục cần thiết
- Copy data từ `../experiments/test-suite-sql-eval/`
- Copy questions từ `../Data Set/`
- Validate setup

**Option 2: Thủ công**

Xem chi tiết trong: `data/README.md`

### Bước 5: Kiểm tra Setup

```powershell
# Test imports và khởi tạo models
python test_system.py
```

**Kết quả mong đợi:**
```
Testing Multi-Agent SQL System
==================================================
[*] Importing core modules...
[OK] Core models imported successfully
[*] Importing model classes...
[OK] Model3Step imported
[OK] Model4Step imported
[OK] Model6Step imported
...
[SUCCESS] System test completed successfully!
```

## 🧪 Chạy Benchmark

### Quick Test (10 câu hỏi)

```powershell
python run_simple_benchmark.py
```

Sẽ chạy test với:
- 10 câu hỏi từ dataset
- Cả 3 models (3-step, 4-step, 6-step)
- Output: `output/predict_*.sql`
- Logs: `logs/benchmark_*.log`

### Full Benchmark (50+ câu hỏi)

```powershell
# Chạy tất cả models với 50 câu hỏi
python experiments/run_benchmark.py --model all --questions 50

# Chạy model cụ thể
python experiments/run_benchmark.py --model 4_step --questions 100

# Chạy với evaluation
python experiments/run_benchmark.py --model all --questions 50
```

**Options:**
- `--model`: Chọn model (3_step, 4_step, 6_step, all)
- `--questions`: Số câu hỏi test
- `--db-id`: Database cụ thể
- `--runs`: Số lần chạy để tính trung bình
- `--no-eval`: Bỏ qua evaluation
- `--verbose`: Hiển thị chi tiết

### So sánh Models

```powershell
# So sánh tất cả results trong output/
python experiments/compare_models.py --results-dir output/

# So sánh specific files
python experiments/compare_models.py --result-files output/results_3-Step_*.json --result-files output/results_4-Step_*.json

# Export to markdown
python experiments/compare_models.py --results-dir output/ --format markdown --output comparison.md
```

### Phân tích Chi tiết

```powershell
# Analyze specific result file
python experiments/analyze_results.py --result-file output/results_4-Step_20241028.json

# Detailed analysis with output
python experiments/analyze_results.py --result-file output/results_4-Step_20241028.json --detailed --output analysis.txt
```

### Tạo Report

```powershell
# Generate Markdown report
python experiments/generate_report.py --results-dir output/ --output report.md

# Generate HTML report with details
python experiments/generate_report.py --results-dir output/ --output report.html --include-details
```

## 📊 Cấu trúc Output

```
output/
├── predict_3-Step_Lightweight_20241028_120000.sql     # SQL predictions
├── predict_4-Step_Balanced_20241028_120000.sql
├── predict_6-Step_Enhanced_20241028_120000.sql
├── results_3-Step_Lightweight_20241028_120000.json   # Detailed metrics
├── results_4-Step_Balanced_20241028_120000.json
├── results_6-Step_Enhanced_20241028_120000.json
└── comparison_20241028_120000.json                    # Model comparison

logs/
└── benchmark_20241028_120000.log                      # Execution logs

data/
├── test_questions/        # Test datasets
├── schemas/               # Database schemas
└── results/               # Organized results
    ├── model_3_step/
    ├── model_4_step/
    └── model_6_step/
```

## 🔧 Troubleshooting

### Lỗi: ImportError

**Nguyên nhân:** Virtual environment chưa được activate hoặc dependencies chưa cài

**Giải pháp:**
```powershell
.\venv\Scripts\activate
pip install -r requirements.txt
```

### Lỗi: API Key Error

**Nguyên nhân:** File `.env` chưa có hoặc API key sai

**Giải pháp:**
1. Kiểm tra file `.env` tồn tại
2. Kiểm tra API key đã được set đúng
3. Kiểm tra API key còn valid

```powershell
# Test API key
python -c "import google.generativeai as genai; from dotenv import load_dotenv; import os; load_dotenv(); genai.configure(api_key=os.getenv('GEMINI_API_KEY')); print('API Key OK!')"
```

### Lỗi: File not found (tables.json, database)

**Nguyên nhân:** Data chưa được setup

**Giải pháp:**
```powershell
python setup_data.py
```

### Lỗi: Out of Memory

**Nguyên nhân:** Load quá nhiều questions hoặc RAM không đủ

**Giải pháp:**
- Giảm số questions: `--questions 10`
- Chạy từng model riêng: `--model 3_step`
- Tăng RAM hoặc close các ứng dụng khác

## 📚 Tài liệu tham khảo

- **README.md** - Tổng quan dự án
- **data/README.md** - Hướng dẫn data structure
- **config/prompts/** - Prompt templates cho từng agent
- **src/core/models.py** - Data models
- **requirements.txt** - Python dependencies

## 🎯 Next Steps

Sau khi setup thành công:

1. **Chạy test nhỏ** để verify system hoạt động
```powershell
python run_simple_benchmark.py
```

2. **Chạy full benchmark** với dataset chính
```powershell
python experiments/run_benchmark.py --model all --questions 50
```

3. **Phân tích kết quả** và so sánh models
```powershell
python experiments/compare_models.py --results-dir output/
```

4. **Tạo report** cho luận văn
```powershell
python experiments/generate_report.py --results-dir output/ --output report.md --include-details
```

## ✅ Checklist Setup

- [ ] Virtual environment đã activate
- [ ] Dependencies đã cài đặt (`pip install -r requirements.txt`)
- [ ] File `.env` đã tạo với API key
- [ ] Data đã setup (`python setup_data.py`)
- [ ] Test system thành công (`python test_system.py`)
- [ ] Chạy benchmark thử nghiệm (`python run_simple_benchmark.py`)
- [ ] Xem logs không có lỗi

## 💡 Tips

1. **Tiết kiệm API calls:** Start với `--questions 10` để test
2. **Debug:** Dùng `--verbose` flag để xem chi tiết
3. **Multiple runs:** Dùng `--runs 3` để kết quả ổn định hơn
4. **Logs:** Luôn check logs trong `logs/` nếu có lỗi
5. **Results:** Backup results trong `output/` trước khi chạy lại

---

**Liên hệ:** Nếu gặp vấn đề, check logs hoặc xem documentation trong các file README.

