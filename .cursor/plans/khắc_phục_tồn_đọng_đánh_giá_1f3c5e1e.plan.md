---
name: Khắc phục tồn đọng đánh giá
overview: "Khắc phục 4 điểm yếu chính và các lỗi hình thức trong Paper.tex theo kết quả đánh giá chuyên gia: bổ sung bảng ablation model-assignment, giảm nhẹ confound backbone, ghi nguồn gốc số liệu cost/latency, giải thích bất thường Extra Hard, và dọn preamble."
todos:
  - id: provenance-cost
    content: Thêm câu nguồn gốc số liệu cho Table tab:cost
    status: pending
  - id: explain-extrahard
    content: Giải thích bất thường Extra Hard > Hard sau Table tab:difficulty
    status: pending
  - id: cleanup-preamble
    content: Dọn preamble trùng package, xóa inputenc cp1251, sửa institute, xóa comment cũ
    status: pending
  - id: ablation-table
    content: Nhận số liệu và thêm bảng tab:modelablation, sửa Section 3.4
    status: pending
  - id: backbone-confound
    content: Xử lý confound backbone theo nhánh có/không dữ liệu 4-step GPT-4o
    status: pending
  - id: final-consistency
    content: Rà soát nhất quán cite key và số liệu giữa các bảng
    status: pending
isProject: false
---

# Khắc phục tồn đọng sau đánh giá chuyên gia

File đích: [Springer_Nature_LaTeX_Template/Paper.tex](Springer_Nature_LaTeX_Template/Paper.tex). Các mục xếp theo mức nghiêm trọng giảm dần, đúng thứ tự trong bản đánh giá.

## 1. Bảng ablation model-assignment (nặng nhất — cần số liệu từ bạn)

Hiện Section 3.4 (dòng ~219) claim các cấu hình thuần nhất "were less favorable" mà không có số.

- **Bạn cung cấp**: EM/EX (+ latency, + token count nếu có log) cho từng cấu hình đã chạy full 1.034 câu: all-Gemini-2.5-Flash, all-GPT-4o, all-Claude-Sonnet-4, all-Claude-Opus-4, và mixed (đã có: 77.8/85.6).
- Thêm bảng mới `tab:modelablation` vào Section 4 (Experimental setup) hoặc cuối Section 3: cột Configuration / EM / EX / Latency; caption ghi rõ "full 1,034-question development set, same protocol".
- Cột cost: chỉ thêm nếu có token count đã log, kèm ghi chú "estimated from logged token usage and provider list prices"; nếu không có thì bỏ cột cost.
- Sửa đoạn dòng ~219: thay claim định tính bằng trỏ vào bảng ("Table~\ref{tab:modelablation} reports the homogeneous-assignment runs that motivated this choice").
- Cập nhật câu Introduction (đã sửa ở Task 2) để trỏ thêm vào bảng ablation.

## 2. Giảm nhẹ confound backbone 4-step vs 6-step

Limitations hiện thừa nhận thí nghiệm "Priority follow-up" (4-step với GPT-4o ở Analyzer) chưa chạy.

- **Nếu bạn đã chạy** cấu hình này (hoặc chạy được trong thời gian sửa bài): thêm 1 dòng vào `tab:main` + 2–3 câu ở Section 5, chuyển đoạn "Priority follow-up experiment" ở Limitations thành kết quả thực. Đây là nâng cấp giá trị nhất của cả bài.
- **Nếu không chạy được**: dùng dữ liệu mục 1 — nếu có run all-GPT-4o 6-step, thêm 1–2 câu ở Limitations lập luận biên (bounding argument) về mức đóng góp tối đa của backbone; giữ nguyên phần thừa nhận hạn chế.

## 3. Ghi nguồn gốc số liệu Table tab:cost

- Thêm 1–2 câu vào Section 5.7 (dòng ~401): token count và latency p50/p90 được log từ chính các run 1.034 câu (xác nhận với bạn: số trong bảng lấy từ log run thật hay ước tính? nếu ước tính phải ghi rõ hoặc thay bằng số log).

## 4. Giải thích bất thường Extra Hard > Hard trong Table tab:difficulty

- Thêm 2–3 câu sau bảng (dòng ~322): thừa nhận EX của nhóm Extra Hard (85.5/87.3) cao hơn Hard và Medium ở baseline; giải thích khả dĩ (câu extra dài thường trả về tập kết quả nhỏ/rỗng nên EX dễ trùng; phân bố database không đều giữa các nhóm) và ghi rõ đây là đặc tính của metric EX trên Spider, không phải bằng chứng hệ thống làm tốt hơn ở câu khó nhất.

## 5. Dọn hình thức (không cần dữ liệu)

- Xóa package trùng trong preamble: `graphicx`, `multirow`, `algorithm` nạp 2 lần; xóa `\usepackage[cp1251]{inputenc}` (encoding Cyrillic, nguy cơ lỗi ký tự).
- Xóa các khối comment dài đã lỗi thời (dòng ~112–124 contributions cũ, ~139–149 Related Work cũ — trong đó còn cite key `naveed2026tursio` đã xóa khỏi bib).
- Sửa `\institute`: bổ sung "Hanoi University of Science and Technology" vào trước "School of Information and Communications Technology".

## Trình tự thực hiện

1. Làm ngay mục 3 (câu provenance), 4 (giải thích Extra Hard), 5 (dọn hình thức) — không phụ thuộc dữ liệu.
2. Nhận số liệu benchmark từ bạn → làm mục 1 (bảng ablation).
3. Tùy bạn xác nhận có/không chạy được thí nghiệm 4-step + GPT-4o Analyzer → làm mục 2 theo nhánh tương ứng.
4. Rà lại toàn bộ cite key ↔ bib entry và tính nhất quán số liệu giữa các bảng sau khi sửa.

## Số liệu cần bạn cung cấp trước khi triển khai mục 1–3

- EM/EX + latency của 4 cấu hình thuần nhất (full 1.034 câu).
- Token count đã log (nếu có) để quyết định giữ/bỏ cột cost.
- Xác nhận nguồn gốc số trong Table `tab:cost` hiện tại (log thật hay ước tính).
- Có/không kết quả run 4-step với GPT-4o ở Question Analyzer.