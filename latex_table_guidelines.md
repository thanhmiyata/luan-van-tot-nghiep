# Hướng dẫn Format Bảng trong LaTeX

## Các Giải pháp cho Bảng Nhiều Cột

### 1. **Rút gọn tên cột** ✅ (Đã áp dụng)
- Sử dụng từ viết tắt: "Exact Match" thay vì "Độ chính xác Khớp chính xác"
- Giải thích trong caption: Thêm chú thích ở cuối bảng

### 2. **Xoay bảng (Landscape)** - Khuyến nghị cho Bảng Y và W

```latex
\usepackage{pdflscape}  % Thêm vào preamble

\begin{landscape}
\begin{table}[h]
\centering
\small  % Hoặc \footnotesize cho font nhỏ hơn
\caption{So sánh hiệu suất giữa cấu hình cùng một mô hình và cấu hình nhiều mô hình}
\label{tab:model-config}
\begin{tabular}{|l|c|c|c|c|c|}
\hline
Cấu hình & Exact Match (\%) & Execution (\%) & Field Select (\%) & Chi phí & Độ phức tạp \\
\hline
Cùng một mô hình & 78.0 & 86.0 & 90.0 & Thấp & Thấp \\
Nhiều mô hình & 79.0 & 87.0 & 90.5 & Cao & Cao \\
\hline
\end{tabular}
\end{table}
\end{landscape}
```

### 3. **Sử dụng tabularx** - Tự động điều chỉnh độ rộng

```latex
\usepackage{tabularx}  % Thêm vào preamble

\begin{table}[h]
\centering
\small
\caption{So sánh latency/compute giữa các biến thể}
\label{tab:latency}
\begin{tabularx}{\textwidth}{|l|X|X|X|X|X|}
\hline
Quy trình & Latency (ms) & Tokens & Chi phí & Ghi chú \\
\hline
4 bước & 1350 & 6.5k & ~1.00× & Baseline \\
6 bước & 2100 & 9.5k & ~1.45× & Thêm lập kế hoạch \& tinh chỉnh \\
\hline
\end{tabularx}
\end{table}
```

### 4. **Chia bảng thành 2 bảng nhỏ hơn** - Cho Bảng Y

**Bảng Y1: So sánh Độ chính xác**
```latex
\begin{table}[h]
\centering
\caption{So sánh độ chính xác giữa các cấu hình}
\begin{tabular}{|l|c|c|c|}
\hline
Cấu hình & Exact Match (\%) & Execution (\%) & Field Select (\%) \\
\hline
Cùng một mô hình & 78.0 & 86.0 & 90.0 \\
Nhiều mô hình & 79.0 & 87.0 & 90.5 \\
\hline
\end{tabular}
\end{table}
```

**Bảng Y2: So sánh Chi phí và Độ phức tạp**
```latex
\begin{table}[h]
\centering
\caption{So sánh chi phí và độ phức tạp triển khai}
\begin{tabular}{|l|c|c|}
\hline
Cấu hình & Chi phí Tính toán & Độ phức tạp Triển khai \\
\hline
Cùng một mô hình & Thấp & Thấp \\
Nhiều mô hình & Cao & Cao \\
\hline
\end{tabular}
\end{table}
```

### 5. **Sử dụng font nhỏ hơn**

```latex
\begin{table}[h]
\centering
\footnotesize  % Hoặc \tiny cho rất nhỏ
\caption{...}
\begin{tabular}{...}
...
\end{tabular}
\end{table}
```

### 6. **Sử dụng longtable** - Cho bảng dài

```latex
\usepackage{longtable}  % Thêm vào preamble

\begin{longtable}{|l|c|c|c|c|c|}
\caption{So sánh hiệu suất...} \\
\hline
Cấu hình & Exact Match (\%) & Execution (\%) & Field Select (\%) & Chi phí & Độ phức tạp \\
\hline
\endfirsthead
\hline
Cấu hình & Exact Match (\%) & Execution (\%) & Field Select (\%) & Chi phí & Độ phức tạp \\
\hline
\endhead
\hline
\endfoot
Cùng một mô hình & 78.0 & 86.0 & 90.0 & Thấp & Thấp \\
Nhiều mô hình & 79.0 & 87.0 & 90.5 & Cao & Cao \\
\end{longtable}
```

### 7. **Sử dụng rotatebox** - Xoay một phần bảng

```latex
\usepackage{graphicx}  % Thêm vào preamble

\begin{table}[h]
\centering
\caption{...}
\rotatebox{90}{%
\begin{tabular}{|l|c|c|c|c|c|}
...
\end{tabular}%
}
\end{table}
```

## Khuyến nghị cho từng bảng:

- **Bảng X** (4 cột): Giữ nguyên, có thể dùng `\small`
- **Bảng Y** (6 cột): Dùng `landscape` hoặc chia thành 2 bảng
- **Bảng Z** (4 cột): Giữ nguyên, có thể dùng `\small`
- **Bảng W** (5 cột): Dùng `tabularx` hoặc `landscape`
- **Bảng V** (4 cột): Giữ nguyên

## Template LaTeX hoàn chỉnh cho bảng:

```latex
\begin{table}[htbp]
\centering
\small
\caption{Tên bảng}
\label{tab:table-label}
\begin{tabular}{|l|c|c|c|}
\hline
Cột 1 & Cột 2 & Cột 3 & Cột 4 \\
\hline
Dòng 1 & Giá trị & Giá trị & Giá trị \\
Dòng 2 & Giá trị & Giá trị & Giá trị \\
\hline
\end{tabular}
\end{table}
```

## Packages cần thiết:

```latex
\usepackage{booktabs}      % Để có đường kẻ đẹp hơn
\usepackage{tabularx}        % Bảng tự động điều chỉnh
\usepackage{longtable}      % Bảng dài nhiều trang
\usepackage{pdflscape}      % Xoay trang
\usepackage{graphicx}       % Xoay bảng
\usepackage{array}          % Định dạng cột nâng cao
```

