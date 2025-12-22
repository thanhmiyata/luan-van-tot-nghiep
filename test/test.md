OK anh, dưới đây là **bản ghi chú kỹ thuật vắn tắt – đúng kiểu DEV ngân hàng**, tập trung **đủ để trả lời phỏng vấn**, không học thừa.

---

# 1️⃣ ISO 8583 (Chuẩn giao dịch thẻ)

### 🔹 ISO 8583 là gì?

* Chuẩn **message-based** dùng trong **giao dịch thẻ** (ATM, POS, Payment switching)
* Không phải protocol mạng, mà là **cấu trúc bản tin**

👉 Dùng để:

* Rút tiền
* Thanh toán
* Truy vấn số dư
* Hoàn tiền

---

## 🔸 Cấu trúc message ISO 8583

```
MTI | Bitmap | Data Elements (Fields)
```

---

## 2️⃣ MTI (Message Type Indicator)

### 🔹 MTI là gì?

* Mã **4 chữ số** xác định **loại giao dịch + trạng thái**

### 🔹 Cấu trúc MTI

| Vị trí | Ý nghĩa       |
| ------ | ------------- |
| 1      | Phiên bản ISO |
| 2      | Loại message  |
| 3      | Chức năng     |
| 4      | Nguồn gửi     |

### 🔹 Ví dụ

| MTI  | Ý nghĩa                        |
| ---- | ------------------------------ |
| 0200 | Financial Transaction Request  |
| 0210 | Financial Transaction Response |
| 0400 | Reversal Request               |
| 0410 | Reversal Response              |
| 0800 | Network Management Request     |

👉 **0200 → 0210** là cặp rất hay hỏi.

---

## 3️⃣ Bitmap

### 🔹 Bitmap là gì?

* Chuỗi **bit** cho biết **field nào xuất hiện trong message**
* Không có bitmap → không biết field nào có mặt

### 🔹 Có mấy loại?

* **Primary Bitmap**: field 1–64
* **Secondary Bitmap**: field 65–128 (nếu bit 1 = 1)

👉 Bitmap = **bản đồ dữ liệu**.

---

## 4️⃣ Các Field dữ liệu quan trọng trong ISO 8583

| Field | Tên                    | Ý nghĩa             |
| ----- | ---------------------- | ------------------- |
| 2     | PAN                    | Số thẻ              |
| 3     | Processing Code        | Loại giao dịch      |
| 4     | Amount                 | Số tiền             |
| 7     | Transmission Date Time | Thời điểm giao dịch |
| 11    | STAN                   | Số tham chiếu       |
| 12    | Local Time             | Giờ giao dịch       |
| 13    | Local Date             | Ngày giao dịch      |
| 37    | Retrieval Reference    | Tra soát            |
| 39    | Response Code          | Kết quả (00 = OK)   |
| 41    | Terminal ID            | ATM/POS             |
| 49    | Currency Code          | Mã tiền             |
| 52    | PIN Data               | PIN đã mã hóa       |

👉 Dev **không cần nhớ hết**, chỉ cần biết **vai trò**.

---

# 5️⃣ ATM / POS / Payment Switching

### 🔹 Payment Switching là gì?

* Hệ thống **định tuyến giao dịch thẻ**
* Trung gian giữa:

```
ATM/POS → Switch → Core Banking → Response
```

### 🔹 Đặc điểm kỹ thuật

* **Realtime**
* Độ trễ thấp
* Timeout nghiêm ngặt
* Phải **rollback nếu fail**

👉 Sai ở switch = mất tiền thật.

---

# 6️⃣ MIS – FTP – DataWarehouse

## 🔹 MIS (Management Information System)

* Hệ thống **báo cáo quản trị**
* Không realtime
* Lấy dữ liệu từ Core / DW

---

## 🔹 FTP trong ngân hàng

* Truyền file batch:

  * Đối soát
  * Báo cáo
  * Giao dịch cuối ngày
* Dùng cho **EOD (End Of Day)**

---

## 🔹 DataWarehouse

* Kho dữ liệu trung tâm
* Phục vụ:

  * BI
  * Báo cáo
  * Phân tích

👉 DW **không thay Core Banking**.

---

# 7️⃣ OLTP vs OLAP (RẤT HAY HỎI)

| Tiêu chí  | OLTP         | OLAP          |
| --------- | ------------ | ------------- |
| Mục đích  | Giao dịch    | Phân tích     |
| Ví dụ     | Core Banking | DataWarehouse |
| Thời gian | Realtime     | Batch         |
| Update    | Nhiều        | Ít            |
| Query     | Nhỏ          | Nặng          |

👉 Câu trả lời chuẩn:

> “Core Banking là OLTP, DataWarehouse là OLAP.”

---

# 8️⃣ SOA (Service-Oriented Architecture)

### 🔹 SOA là gì?

* Kiến trúc chia hệ thống thành **service độc lập**
* Giao tiếp qua interface rõ ràng

### 🔹 Trong ngân hàng

* Core
* Card
* Internet Banking
* Mobile Banking
* BI

👉 Mỗi hệ **deploy riêng – giao tiếp qua service**.

---

# 9️⃣ OOAD (Object-Oriented Analysis & Design)

### 🔹 OOAD là gì?

* Phân tích & thiết kế hệ thống theo **đối tượng**
* Không phải chỉ là OOP code

### 🔹 Bao gồm

* Use case
* Class diagram
* Sequence diagram
* Responsibility

👉 Ngân hàng thích dev **biết phân tích trước khi code**.

---

# 🔟 Business Intelligence (BI)

### 🔹 BI là gì?

* Tập hợp công cụ:

  * Báo cáo
  * Dashboard
  * Phân tích dữ liệu

### 🔹 BI dùng dữ liệu từ đâu?

* DataWarehouse
* Không truy trực tiếp Core

👉 Dùng cho:

* Quản trị
* Kinh doanh
* Rủi ro

---

# 🧠 CÂU CHỐT ĐỂ ĐI PHỎNG VẤN

Anh chỉ cần nhớ **5 câu này**:

1. ISO 8583 là chuẩn message cho giao dịch thẻ
2. MTI xác định loại giao dịch, bitmap xác định field
3. ATM/POS là realtime, cực kỳ nhạy timeout
4. Core Banking = OLTP, DataWarehouse = OLAP
5. SOA giúp hệ thống ngân hàng mở rộng và tích hợp

---

Nếu anh muốn, em làm tiếp cho anh:

* ✅ **Sơ đồ luồng giao dịch thẻ (vẽ dễ nhớ)**
* ✅ **20 câu hỏi kỹ thuật ngân hàng hay ra**
* ✅ **Bản PDF “ôn trước phỏng vấn 1 đêm”**

Anh chỉ cần nói **làm tiếp phần nào** 👍
