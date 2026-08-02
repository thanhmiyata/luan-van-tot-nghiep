---
name: "Memory Management Skill"
description: "Quy trình duy trì và cập nhật bộ nhớ dự án để tiết kiệm token và thời gian."
---

# Kỹ năng Quản lý Bộ nhớ

Kỹ năng này giúp AI duy trì bối cảnh liên tục giữa các phiên làm việc mà không cần người dùng giải thích lại.

## Khi bắt đầu phiên chat mới
1. Đọc file `CLAUDE.md` để nắm các quy định chung.
2. Đọc file `MEMORY.md` để biết công việc đang dừng lại ở đâu.
3. KHÔNG thực hiện quét toàn bộ thư mục (ls -R) trừ khi có thay đổi lớn về cấu trúc file.

## Trong khi làm việc
- Nếu có một quyết định quan trọng (thay đổi thuật toán, đổi tên file chính, v.v.), hãy note lại ngay.

## Trước khi kết thúc (hoặc sau khi xong 1 task lớn)
- Cập nhật mục "Đã hoàn thành gần đây" và "Trạng thái hiện tại" trong `MEMORY.md`.
- Ghi lại các file quan trọng mới được tạo hoặc sửa đổi.

## Script hỗ trợ
Sử dụng các lệnh `grep` để tìm kiếm thông tin nhanh chóng thay vì đọc toàn bộ file dài.
