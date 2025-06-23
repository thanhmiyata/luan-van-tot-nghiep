# Experiments - Multi-Agent Text-to-SQL System

Thư mục này chứa 2 thực nghiệm chính của luận văn về so sánh hiệu quả Single-Agent vs Multi-Agent approach trong việc chuyển đổi Natural Language sang PostgreSQL queries.

## Cấu trúc thực nghiệm

### 📁 experiment1_single_agent/
**Baseline Experiment - Single-Agent System**
- **Mục tiêu**: Thiết lập baseline với hệ thống single-agent
- **Target Accuracy**: 70-80%
- **Tech Stack**: GPT-4, Claude-3.5-Sonnet, Gemini-1.5-Pro
- **Timeline**: Tháng 3 (Implementation + Testing)
- **Status**: ✅ Ready to run

### 📁 experiment2_multi_agent/ 
**Advanced Experiment - Multi-Agent System**
- **Mục tiêu**: Triển khai hệ thống 6-agent theo paper thầy hướng dẫn
- **Target Accuracy**: 90%+ (paper đạt 91.95%)
- **Tech Stack**: LLM-Embedder, GLiNER, BGE Rerank, Qdrant
- **Timeline**: Tháng 3-4 (Implementation + Testing)
- **Status**: 📋 Planned (chưa triển khai)

## Phương pháp thực nghiệm

### Dataset
- **Spider Benchmark**: Đánh giá trên dataset chuẩn
- **DVD Rental Schema**: Test trên schema thực tế PostgreSQL
- **Custom Queries**: 50+ câu hỏi (English + Vietnamese)

### Metrics đánh giá
1. **Execution Accuracy**: SQL syntax + semantic correctness
2. **Response Time**: Thời gian từ query → kết quả
3. **Error Rate**: Tỷ lệ câu truy vấn failed
4. **User Satisfaction**: Đánh giá chất lượng response

### So sánh và Ablation Studies
- Single-Agent vs Multi-Agent accuracy
- Multi-LLM comparison (GPT-4 vs Claude vs Gemini)
- Component analysis trong Multi-Agent system
- Cost-effectiveness analysis

## Chạy thực nghiệm

### Experiment 1 (Single-Agent)
```bash
cd experiment1_single_agent
venv\Scripts\activate
pip install -r requirements.txt
python test_single_agent.py
```

### Experiment 2 (Multi-Agent) 
```bash
cd experiment2_multi_agent
venv\Scripts\activate
pip install -r requirements.txt
# TODO: Implement multi-agent system
```

## Kết quả mong đợi

| Aspect | Single-Agent | Multi-Agent | Improvement |
|--------|-------------|-------------|-------------|
| Accuracy | 70-80% | 90%+ | +15-20% |
| Response Time | < 5s | < 10s | -5s |
| Complexity | Low | High | - |
| Maintenance | Easy | Complex | - |

## Dependencies riêng biệt

Mỗi thực nghiệm có virtual environment và dependencies riêng để:
- ✅ Tránh conflict dependencies
- ✅ Dễ dàng reproduce results  
- ✅ Quản lý version control tốt hơn
- ✅ Deploy độc lập 