# Hướng dẫn Overleaf — Springer Nature (`sn-article.tex` + `sn-bibliography.bib`)

Tài liệu này map **từng file** trong project Overleaf của bạn với **nội dung đã soạn** trong repo (thư mục `report/latex/`). Template gốc lấy cấu trúc từ [Springer Nature sn-article.tex mẫu](https://raw.githubusercontent.com/godkingjay/springer-nature-latex-template/master/sn-article.tex) (giống bản Overleaf “Springer Nature LaTeX Template”).

---

## 1. Các file trong Overleaf và việc bạn cần làm

| File trên Overleaf | Việc làm |
|--------------------|----------|
| **`sn-article.tex`** | Giữ phần `\documentclass`, `\usepackage`, `\begin{document}`; **thay** khối metadata (`\title` … `\keywords`) và **toàn bộ nội dung sau `\maketitle`** bằng file tương ứng bên dưới. |
| **`sn-bibliography.bib`** | **Xóa** mục mẫu (`bib1` …); **dán toàn bộ** nội dung file `report/latex/sn_bibliography_pccda.bib` (hoặc đổi tên file thành `sn-bibliography.bib` và upload đè). |
| **`sn-jnl.cls`** | **Không sửa** — class của Springer. |
| **`sn-*.bst`** | **Không sửa** — style trích dẫn khớp với `\documentclass[...,sn-aps]{sn-jnl}` (hoặc `sn-mathphys`, …). Bạn đang mở `sn-aps.bst` thì thường `\documentclass` đang chọn **sn-aps**; giữ nhất quán. |
| **`fig.eps` / hình khác** | Bài này dùng **TikZ** trong `sn_article_body_after_maketitle.tex`; không bắt buộc `fig.eps`. Có thể xóa figure mẫu trong `sn-article.tex` nếu còn tham chiếu. |

**Lưu ý của Springer (ghi trong template):** khi nộp bản cuối, họ khuyến nghị **một file `.tex` duy nhất**, không dùng `\input{...}`. Cách làm thực tế: trong quá trình soạn, bạn **copy** từng phần từ các file dưới đây vào `sn-article.tex`; trước khi nộp, **dán nối** thành một `sn-article.tex` hoàn chỉnh.

---

## 2. Thứ tự copy vào `sn-article.tex`

### Bước A — Preamble (tùy chọn, cho hình TikZ)

Mở `sn-article.tex`, tìm khối `\usepackage{...}` (sau `\documentclass`), **thêm** nội dung file:

- `report/latex/sn_article_preamble_tikz.tex`

*(Nếu biên dịch báo thiếu TikZ, Overleaf gói TeX Live đầy đủ thường đã có `tikz`.)*

### Bước B — Tiêu đề, tác giả, abstract, keywords

Trong `sn-article.tex`, **thay** từ dòng `\title[...]` đến hết `\keywords{...}` (giữ nguyên `\maketitle` ngay sau đó) bằng nội dung:

- `report/latex/sn_article_title_metadata.tex`

**Bắt buộc chỉnh tay:** `\author`, `\affil`, `\email` theo tên thật và cơ quan của bạn (cú pháp `\fnm{}` `\sur{}` như template).

### Bước C — Thân bài (sau `\maketitle`)

1. Trong `sn-article.tex`, **xóa toàn bộ** các `\section{...}` mẫu (Introduction mẫu, Tables, Figures, Algorithms, …) **từ ngay sau `\maketitle`** cho đến **trước** `\backmatter` (hoặc trước `\bibliography{...}` nếu template không dùng `\backmatter`).
2. **Dán** toàn bộ nội dung file:

- `report/latex/sn_article_body_after_maketitle.tex`

3. Giữ nguyên cuối file template:

   - `\bibliography{sn-bibliography}`  
   - (và `\end{document}`)

Nếu bạn đổi tên file bib, sửa luôn `\bibliography{tên-file-không-có-đuôi-bib}`.

---

## 3. File `sn-bibliography.bib`

1. Mở `sn-bibliography.bib` trên Overleaf.
2. Xóa hết entry mẫu.
3. Copy **toàn bộ** từ `report/latex/sn_bibliography_pccda.bib` vào.

Các `\cite{...}` trong `sn_article_body_after_maketitle.tex` đã khớp key trong file bib này (vd. `yu2018spider`, `zhong2017seq2sql`, …).

---

## 4. Biên dịch trên Overleaf (tài liệu chính thức)

Theo [Overleaf — Bibliography with BibTeX](https://www.overleaf.com/learn/latex/Bibliography_management_with_bibtex):

1. Menu **Logs and output files** — nếu có lỗi trích dẫn, chạy đủ chuỗi: **pdfLaTeX → BibTeX → pdfLaTeX → pdfLaTeX**.
2. Trên Overleaf thường bật **Auto-compile**; lần đầu sau khi thêm `.bib`, dùng nút **Recompile** hoặc **Clear cached files** nếu còn `[?]`.

[Springer Nature — submit LaTeX via Overleaf](https://support.springernature.com/en/support/solutions/articles/6000127538-submit-a-latex-manuscript-to-a-springer-nature-journal-using-overleaf) (tham khảo quy trình nộp; PCCDA có thể yêu cầu thêm zip — làm theo hướng dẫn hội nghị).

---

## 5. Checklist nhanh

- [ ] `\documentclass[...]{sn-jnl}` khớp style thầy yêu cầu (vd. `sn-aps`, `sn-mathphys`).
- [ ] Đã dán `sn_article_preamble_tikz.tex` nếu dùng figure TikZ.
- [ ] Đã thay title/authors/abstract/keywords.
- [ ] Đã xóa section mẫu và dán `sn_article_body_after_maketitle.tex`.
- [ ] Đã thay `sn-bibliography.bib` bằng `sn_bibliography_pccda.bib`.
- [ ] Recompile không còn `Citation undefined` / `undefined reference`.

---

## 6. Danh sách file trong repo (đường dẫn đầy đủ)

| Mục đích | Đường dẫn |
|----------|-----------|
| TikZ preamble | `report/latex/sn_article_preamble_tikz.tex` |
| Title + abstract + keywords | `report/latex/sn_article_title_metadata.tex` |
| Toàn bộ section + bảng + hình | `report/latex/sn_article_body_after_maketitle.tex` |
| BibTeX đầy đủ 18 tham chiếu | `report/latex/sn_bibliography_pccda.bib` |
| Bản Markdown gốc (đối chiếu) | `report/conference-ready-12.md` |

Nếu template báo lỗi `\botrule`, mở `user-manual.pdf` trong project — một số bản dùng `\bottomrule` của `booktabs`; khi đó thay toàn bộ `\botrule` → `\bottomrule` trong file body.
