# 📊 Comprehensive SQL Benchmark Report - GPT-4 vs Expected SQL

**Thời gian tạo báo cáo:** 2025-06-24 13:16:29  
**Phương pháp đánh giá:** Execution-based comparison theo tiêu chuẩn benchmark  

---

## 🎯 **TÓM TẮT TỔNG QUAN**

| Metric | Giá trị |
|--------|---------|
| **Tổng số câu hỏi** | 39 |
| **Overall Accuracy** | **7.7%** |
| **Average Total Score** | **6.8/100** |
| **Thời gian hoàn thành** | 3.8 giây |

---

## 📋 **PHÂN TÍCH THEO TIÊU CHUẨN BENCHMARK**

### 🔍 **Score Breakdown (Weighted Scoring System)**

| Tiêu chuẩn | Trọng số | Điểm trung bình | Đánh giá |
|------------|----------|-----------------|----------|
| **Correctness** | 40% | 6.7/40 | 🔴 Kém |
| **Performance** | 25% | 5.9/25 | 🔴 Kém |
| **Cost Efficiency** | 20% | 3.1/20 | 🔴 Kém |
| **Code Quality** | 15% | 13.1/15 | 🟢 Tốt |

---

## 📊 **PHÂN BỐ ĐIỂM SỐ**

| Mức độ | Số câu | Tỷ lệ |
|--------|--------|-------|
| **Excellent (90-100)** | 0 | 0.0% |
| **Good (70-89)** | 0 | 0.0% |
| **Fair (50-69)** | 0 | 0.0% |
| **Poor (<50)** | 39 | 100.0% |

---

## 🎚️ **HIỆU SUẤT THEO TỪNG LEVEL**

### 🔴 **Level 1 (Basic)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **33.3%** |
| **Average Score** | 11.8/100 |
| **Correct Answers** | 3/9 |

### 🔴 **Level 2 (Intermediate)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **0.0%** |
| **Average Score** | 6.8/100 |
| **Correct Answers** | 0/7 |

### 🔴 **Level 3 (Advanced)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **0.0%** |
| **Average Score** | 6.2/100 |
| **Correct Answers** | 0/6 |

### 🔴 **Level 4 (Expert)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **0.0%** |
| **Average Score** | 4.6/100 |
| **Correct Answers** | 0/7 |

### 🔴 **Level 5 (Master)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **0.0%** |
| **Average Score** | 4.0/100 |
| **Correct Answers** | 0/10 |

---

## 📋 **BẢNG SO SÁNH TỔNG QUAN**

| STT | Câu Benchmark | Expected SQL | Generated SQL |
|-----|---------------|--------------|---------------|
| 1 | **Level 1**<br/>Có bao nhiêu bộ phim trong cơ sở dữ liệu? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM film;
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 2 | **Level 1**<br/>How many customers are in the database? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM customer;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM customer;
``` |
| 3 | **Level 1**<br/>Liệt kê tên tất cả các thể loại phim. | **Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT name FROM category ORDER BY name ASC;
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 4 | **Level 1**<br/>Có bao nhiêu giao dịch thanh toán đã được ghi nhận? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM payment;
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
``` |
| 5 | **Level 1**<br/>How many actors are listed? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM actor;
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
``` |
| 6 | **Level 1**<br/>Tổng cộng có bao nhiêu bản sao phim trong kho? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` |
| 7 | **Level 1**<br/>Show the first name, last name, and email for all customers. | **Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name, email FROM customer;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name, email FROM customer WHERE email IS NOT NULL;
``` |
| 8 | **Level 1**<br/>Liệt kê tất cả các xếp hạng phim khác nhau. | **Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT DISTINCT rating FROM film;
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 9 | **Level 1**<br/>What is the highest single payment amount recorded? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT amount FROM payment ORDER BY amount DESC LIMIT 1;
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
``` |
| 10 | **Level 2**<br/>Show the top 5 customers by total payment amount. | **Perf:** 10.4ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent FROM customer c JOIN payment p ON c.c...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 2.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 11 | **Level 2**<br/>Liệt kê 5 khách hàng chi tiêu nhiều nhất. | **Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS tong_chi_tieu FROM customer c JOIN payment p ON c...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 1.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 12 | **Level 2**<br/>Liệt kê mỗi khách hàng và tổng số phim họ đã thuê. | **Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS so_luong_thue FROM customer c JOIN rental r ...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 1.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 13 | **Level 2**<br/>How many films are in each category? | **Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name, COUNT(fc.film_id) AS number_of_films FROM category c JOIN film_category fc ON c.categ...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM film;
``` |
| 14 | **Level 2**<br/>Có bao nhiêu bộ phim trong mỗi thể loại? | **Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name, COUNT(fc.film_id) AS so_luong_phim FROM category c JOIN film_category fc ON c.categor...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 15 | **Level 2**<br/>What is the total revenue generated by each staff member? | **Perf:** 11.7ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_revenue FROM staff s JOIN payment p ON s.st...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 2.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 16 | **Level 2**<br/>Tổng doanh thu do mỗi nhân viên tạo ra là bao nhiêu? | **Perf:** 0.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS tong_doanh_thu FROM staff s JOIN payment p ON s.s...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 17 | **Level 3**<br/>Tìm 3 thể loại hàng đầu theo tổng doanh thu. | **Perf:** 14.1ms, 3 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.name, SUM(p.amount) AS tong_doanh_thu FROM payment p JOIN rental r ON p.rental_id = r.renta...
``` | **Score:** 5.0/100 ❌<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 18 | **Level 3**<br/>List actors who have worked in both 'Comedy' and 'Horror' films. | **Perf:** 0.0ms, 115 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 7.5/100 ❌<br/>
**Perf:** 0.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
``` |
| 19 | **Level 3**<br/>Liệt kê các diễn viên đã đóng cả phim 'Hài' và 'Kinh dị'. | **Perf:** 0.0ms, 115 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 7.5/100 ❌<br/>
**Perf:** 1.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
``` |
| 20 | **Level 3**<br/>List films that are in stock at store 1 but not at store 2. | **Perf:** 0.0ms, 196 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SEL...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT store_id FROM store;
``` |
| 21 | **Level 3**<br/>What is the total revenue per day of the week? | **Perf:** 0.0ms, 7 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT EXTRACT(DOW FROM payment_date) AS day_of_week, TO_CHAR(payment_date, 'Day') AS day_name, SUM(...
``` | **Score:** 5.0/100 ❌<br/>
**Perf:** 1.1ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 22 | **Level 3**<br/>Tổng doanh thu mỗi ngày trong tuần là bao nhiêu? | **Perf:** 14.3ms, 7 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT EXTRACT(DOW FROM payment_date) AS ngay_trong_tuan_so, TO_CHAR(payment_date, 'Day') AS ten_nga...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 23 | **Level 4**<br/>Liệt kê các phim đã được thuê từ cả hai cửa hàng. | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT store_id FROM store;
``` |
| 24 | **Level 4**<br/>Identify 'loyal' customers who have rented in at least 3 different months. | **Perf:** 0.0ms, 598 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROU...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.6ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 25 | **Level 4**<br/>Xác định những khách hàng 'trung thành' đã thuê trong ít nhất 3 tháng khác nhau. | **Perf:** 0.0ms, 598 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROU...
``` | **Score:** 6.3/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 26 | **Level 4**<br/>What is the total revenue from the top 10% of customers by spending? | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 27 | **Level 4**<br/>Tổng doanh thu từ 10% khách hàng chi tiêu nhiều nhất là bao nhiêu? | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 2.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT SUM(amount) FROM payment;
``` |
| 28 | **Level 4**<br/>For each staff member, show their total number of transactions (rentals and paym... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 1.1ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT rental_id, rental_date, return_date FROM rental LIMIT 10;
``` |
| 29 | **Level 4**<br/>Đối với mỗi nhân viên, hãy hiển thị tổng số giao dịch của họ (lượt thuê và thanh... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 10 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
``` |
| 30 | **Level 5**<br/>Perform a cohort analysis to track the monthly retention rate of customers based... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 31 | **Level 5**<br/>Thực hiện phân tích cohort để theo dõi tỷ lệ giữ chân khách hàng hàng tháng dựa ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 32 | **Level 5**<br/>Calculate the Customer Lifetime Value (LTV) for each customer, defined as their ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 33 | **Level 5**<br/>Tính Giá trị Vòng đời Khách hàng (LTV) cho mỗi khách hàng, được định nghĩa là tổ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 34 | **Level 5**<br/>Identify 'binge-watching' sessions, defined as a customer renting 3 or more film... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 35 | **Level 5**<br/>Xác định các 'phiên xem liên tục', được định nghĩa là một khách hàng thuê 3 phim... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` |
| 36 | **Level 5**<br/>For customers who rented 'AGENT TRUMAN', what other film did they rent most freq... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 37 | **Level 5**<br/>Đối với những khách hàng đã thuê 'AGENT TRUMAN', họ đã thuê phim nào khác thường... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT title FROM film LIMIT 5;
``` |
| 38 | **Level 5**<br/>Identify overstocked films: films with more than 7 copies in inventory that have... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` |
| 39 | **Level 5**<br/>Xác định các phim tồn kho quá nhiều: phim có hơn 7 bản sao trong kho mà không đư... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` |

---

## 📝 **CHI TIẾT TỪNG CÂU HỎI**

### ❌ **Câu 1 (Level 1)**

**Câu hỏi:** Có bao nhiêu bộ phim trong cơ sở dữ liệu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 1 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT COUNT(*) FROM film;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ✅ **Câu 2 (Level 1)**

**Câu hỏi:** How many customers are in the database?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 1 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **21.5/100**

**Expected SQL:**
```sql
SELECT COUNT(*) FROM customer;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM customer;
```

---

### ❌ **Câu 3 (Level 1)**

**Câu hỏi:** Liệt kê tên tất cả các thể loại phim.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 16 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT name FROM category ORDER BY name ASC;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 4 (Level 1)**

**Câu hỏi:** Có bao nhiêu giao dịch thanh toán đã được ghi nhận?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 1 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT COUNT(*) FROM payment;
```

**Generated SQL:**
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
```

---

### ❌ **Câu 5 (Level 1)**

**Câu hỏi:** How many actors are listed?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 1 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT COUNT(*) FROM actor;
```

**Generated SQL:**
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
```

---

### ✅ **Câu 6 (Level 1)**

**Câu hỏi:** Tổng cộng có bao nhiêu bản sao phim trong kho?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.03ms |
| **Rows Returned** | 1 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **21.5/100**

**Expected SQL:**
```sql
SELECT COUNT(*) FROM inventory;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM inventory;
```

---

### ✅ **Câu 7 (Level 1)**

**Câu hỏi:** Show the first name, last name, and email for all customers.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 599 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **21.5/100**

**Expected SQL:**
```sql
SELECT first_name, last_name, email FROM customer;
```

**Generated SQL:**
```sql
SELECT first_name, last_name, email FROM customer WHERE email IS NOT NULL;
```

---

### ❌ **Câu 8 (Level 1)**

**Câu hỏi:** Liệt kê tất cả các xếp hạng phim khác nhau.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 5 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT DISTINCT rating FROM film;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 9 (Level 1)**

**Câu hỏi:** What is the highest single payment amount recorded?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 1 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT amount FROM payment ORDER BY amount DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
```

---

### ❌ **Câu 10 (Level 2)**

**Câu hỏi:** Show the top 5 customers by total payment amount.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 10.38ms | 2.00ms |
| **Rows Returned** | 5 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_spent DESC LIMIT 5;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 11 (Level 2)**

**Câu hỏi:** Liệt kê 5 khách hàng chi tiêu nhiều nhất.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 5 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS tong_chi_tieu FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY tong_chi_tieu DESC LIMIT 5;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 12 (Level 2)**

**Câu hỏi:** Liệt kê mỗi khách hàng và tổng số phim họ đã thuê.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 599 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS so_luong_thue FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY so_luong_thue DESC;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 13 (Level 2)**

**Câu hỏi:** How many films are in each category?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 16 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.name, COUNT(fc.film_id) AS number_of_films FROM category c JOIN film_category fc ON c.category_id = fc.category_id GROUP BY c.name ORDER BY number_of_films DESC;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM film;
```

---

### ❌ **Câu 14 (Level 2)**

**Câu hỏi:** Có bao nhiêu bộ phim trong mỗi thể loại?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 16 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.name, COUNT(fc.film_id) AS so_luong_phim FROM category c JOIN film_category fc ON c.category_id = fc.category_id GROUP BY c.name ORDER BY so_luong_phim DESC;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 15 (Level 2)**

**Câu hỏi:** What is the total revenue generated by each staff member?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 11.71ms | 2.00ms |
| **Rows Returned** | 2 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_revenue FROM staff s JOIN payment p ON s.staff_id = p.staff_id GROUP BY s.staff_id, s.first_name, s.last_name ORDER BY total_revenue DESC;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 16 (Level 2)**

**Câu hỏi:** Tổng doanh thu do mỗi nhân viên tạo ra là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 2 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS tong_doanh_thu FROM staff s JOIN payment p ON s.staff_id = p.staff_id GROUP BY s.staff_id, s.first_name, s.last_name ORDER BY tong_doanh_thu DESC;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 17 (Level 3)**

**Câu hỏi:** Tìm 3 thể loại hàng đầu theo tổng doanh thu.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 14.09ms | 1.00ms |
| **Rows Returned** | 3 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 5.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **5.0/100**

**Expected SQL:**
```sql
SELECT c.name, SUM(p.amount) AS tong_doanh_thu FROM payment p JOIN rental r ON p.rental_id = r.rental_id JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film_category fc ON i.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id GROUP BY c.name ORDER BY tong_doanh_thu DESC LIMIT 3;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 18 (Level 3)**

**Câu hỏi:** List actors who have worked in both 'Comedy' and 'Horror' films.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 115 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **7.5/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Comedy' INTERSECT SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Horror';
```

**Generated SQL:**
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
```

---

### ❌ **Câu 19 (Level 3)**

**Câu hỏi:** Liệt kê các diễn viên đã đóng cả phim 'Hài' và 'Kinh dị'.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 115 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **7.5/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Comedy' INTERSECT SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Horror';
```

**Generated SQL:**
```sql
SELECT first_name, last_name FROM actor LIMIT 10;
```

---

### ❌ **Câu 20 (Level 3)**

**Câu hỏi:** List films that are in stock at store 1 but not at store 2.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 196 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 2;
```

**Generated SQL:**
```sql
SELECT store_id FROM store;
```

---

### ❌ **Câu 21 (Level 3)**

**Câu hỏi:** What is the total revenue per day of the week?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.09ms |
| **Rows Returned** | 7 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 5.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **5.0/100**

**Expected SQL:**
```sql
SELECT EXTRACT(DOW FROM payment_date) AS day_of_week, TO_CHAR(payment_date, 'Day') AS day_name, SUM(amount) AS total_revenue FROM payment GROUP BY day_of_week, day_name ORDER BY day_of_week;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 22 (Level 3)**

**Câu hỏi:** Tổng doanh thu mỗi ngày trong tuần là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 14.29ms | 1.00ms |
| **Rows Returned** | 7 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT EXTRACT(DOW FROM payment_date) AS ngay_trong_tuan_so, TO_CHAR(payment_date, 'Day') AS ten_ngay, SUM(amount) AS tong_doanh_thu FROM payment GROUP BY ngay_trong_tuan_so, ten_ngay ORDER BY ngay_trong_tuan_so;
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

---

### ❌ **Câu 23 (Level 4)**

**Câu hỏi:** Liệt kê các phim đã được thuê từ cả hai cửa hàng.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH ThueCH1 AS (SELECT DISTINCT i.film_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id WHERE i.store_id = 1), ThueCH2 AS (SELECT DISTINCT i.film_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id WHERE i.store_id = 2) SELECT f.title FROM film f WHERE f.film_id IN (SELECT film_id FROM ThueCH1) AND f.film_id IN (SELECT film_id FROM ThueCH2);
```

**Generated SQL:**
```sql
SELECT store_id FROM store;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 24 (Level 4)**

**Câu hỏi:** Identify 'loyal' customers who have rented in at least 3 different months.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.57ms |
| **Rows Returned** | 598 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT DATE_TRUNC('month', r.rental_date)) >= 3;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 25 (Level 4)**

**Câu hỏi:** Xác định những khách hàng 'trung thành' đã thuê trong ít nhất 3 tháng khác nhau.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 598 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **6.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT DATE_TRUNC('month', r.rental_date)) >= 3;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

---

### ❌ **Câu 26 (Level 4)**

**Câu hỏi:** What is the total revenue from the top 10% of customers by spending?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.99ms |
| **Rows Returned** | 0 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH CustomerSpending AS (SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id), TopCustomers AS (SELECT customer_id FROM CustomerSpending ORDER BY total_spent DESC LIMIT (SELECT COUNT(*) / 10 FROM customer)) SELECT SUM(p.amount) FROM payment p WHERE p.customer_id IN (SELECT customer_id FROM TopCustomers);
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 27 (Level 4)**

**Câu hỏi:** Tổng doanh thu từ 10% khách hàng chi tiêu nhiều nhất là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 2.00ms |
| **Rows Returned** | 0 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH ChiTieuKH AS (SELECT customer_id, SUM(amount) AS tong_chi FROM payment GROUP BY customer_id), TopKH AS (SELECT customer_id FROM ChiTieuKH ORDER BY tong_chi DESC LIMIT (SELECT COUNT(*) / 10 FROM customer)) SELECT SUM(p.amount) FROM payment p WHERE p.customer_id IN (SELECT customer_id FROM TopKH);
```

**Generated SQL:**
```sql
SELECT SUM(amount) FROM payment;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 28 (Level 4)**

**Câu hỏi:** For each staff member, show their total number of transactions (rentals and payments).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 1.11ms |
| **Rows Returned** | 0 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH RentalCounts AS (SELECT staff_id, COUNT(*) as rental_count FROM rental GROUP BY staff_id), PaymentCounts AS (SELECT staff_id, COUNT(*) as payment_count FROM payment GROUP BY staff_id) SELECT s.first_name, s.last_name, rc.rental_count, pc.payment_count FROM staff s JOIN RentalCounts rc ON s.staff_id = rc.staff_id JOIN PaymentCounts pc ON s.staff_id = pc.staff_id;
```

**Generated SQL:**
```sql
SELECT rental_id, rental_date, return_date FROM rental LIMIT 10;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 29 (Level 4)**

**Câu hỏi:** Đối với mỗi nhân viên, hãy hiển thị tổng số giao dịch của họ (lượt thuê và thanh toán).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 10 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH DemThue AS (SELECT staff_id, COUNT(*) as so_luong_thue FROM rental GROUP BY staff_id), DemThanhToan AS (SELECT staff_id, COUNT(*) as so_luong_tt FROM payment GROUP BY staff_id) SELECT s.first_name, s.last_name, dt.so_luong_thue, dtt.so_luong_tt FROM staff s JOIN DemThue dt ON s.staff_id = dt.staff_id JOIN DemThanhToan dtt ON s.staff_id = dtt.staff_id;
```

**Generated SQL:**
```sql
SELECT payment_id, amount, payment_date FROM payment LIMIT 10;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 30 (Level 5)**

**Câu hỏi:** Perform a cohort analysis to track the monthly retention rate of customers based on their registration month.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH customer_cohorts AS (SELECT customer_id, DATE_TRUNC('month', create_date) AS cohort_month FROM customer), rental_activity AS (SELECT customer_id, DATE_TRUNC('month', rental_date) AS rental_month FROM rental), cohort_monthly_activity AS (SELECT c.cohort_month, EXTRACT(YEAR FROM r.rental_month) * 12 + EXTRACT(MONTH FROM r.rental_month) - (EXTRACT(YEAR FROM c.cohort_month) * 12 + EXTRACT(MONTH FROM c.cohort_month)) AS month_number, COUNT(DISTINCT r.customer_id) AS active_customers FROM customer_cohorts c JOIN rental_activity r ON c.customer_id = r.customer_id GROUP BY 1, 2), cohort_size AS (SELECT cohort_month, COUNT(1) AS total_customers FROM customer_cohorts GROUP BY 1) SELECT cs.cohort_month::date, cma.month_number, cs.total_customers, cma.active_customers, (cma.active_customers::decimal * 100 / cs.total_customers) as retention_rate FROM cohort_monthly_activity cma JOIN cohort_size cs ON cma.cohort_month = cs.cohort_month WHERE cma.month_number >= 0 ORDER BY 1, 2;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 31 (Level 5)**

**Câu hỏi:** Thực hiện phân tích cohort để theo dõi tỷ lệ giữ chân khách hàng hàng tháng dựa trên tháng đăng ký của họ.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH nhom_khach_hang AS (SELECT customer_id, DATE_TRUNC('month', create_date) AS thang_nhom FROM customer), hoat_dong_thue AS (SELECT customer_id, DATE_TRUNC('month', rental_date) AS thang_thue FROM rental), hoat_dong_nhom_thang AS (SELECT nkh.thang_nhom, EXTRACT(YEAR FROM hdt.thang_thue) * 12 + EXTRACT(MONTH FROM hdt.thang_thue) - (EXTRACT(YEAR FROM nkh.thang_nhom) * 12 + EXTRACT(MONTH FROM nkh.thang_nhom)) AS so_thang, COUNT(DISTINCT hdt.customer_id) AS kh_hoat_dong FROM nhom_khach_hang nkh JOIN hoat_dong_thue hdt ON nkh.customer_id = hdt.customer_id GROUP BY 1, 2), kich_thuoc_nhom AS (SELECT thang_nhom, COUNT(1) AS tong_khach_hang FROM nhom_khach_hang GROUP BY 1) SELECT ktn.thang_nhom::date, hdnt.so_thang, ktn.tong_khach_hang, hdnt.kh_hoat_dong, (hdnt.kh_hoat_dong::decimal * 100 / ktn.tong_khach_hang) as ty_le_giu_chan FROM hoat_dong_nhom_thang hdnt JOIN kich_thuoc_nhom ktn ON hdnt.thang_nhom = ktn.thang_nhom WHERE hdnt.so_thang >= 0 ORDER BY 1, 2;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 32 (Level 5)**

**Câu hỏi:** Calculate the Customer Lifetime Value (LTV) for each customer, defined as their total spending, and show their LTV rank.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH customer_ltv AS (SELECT customer_id, SUM(amount) as ltv FROM payment GROUP BY customer_id) SELECT c.first_name, c.last_name, cl.ltv, RANK() OVER (ORDER BY cl.ltv DESC) as ltv_rank FROM customer_ltv cl JOIN customer c ON cl.customer_id = c.customer_id ORDER BY ltv_rank;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 33 (Level 5)**

**Câu hỏi:** Tính Giá trị Vòng đời Khách hàng (LTV) cho mỗi khách hàng, được định nghĩa là tổng chi tiêu của họ, và hiển thị thứ hạng LTV của họ.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH ltv_khach_hang AS (SELECT customer_id, SUM(amount) as ltv FROM payment GROUP BY customer_id) SELECT c.first_name, c.last_name, lkh.ltv, RANK() OVER (ORDER BY lkh.ltv DESC) as hang_ltv FROM ltv_khach_hang lkh JOIN customer c ON lkh.customer_id = c.customer_id ORDER BY hang_ltv;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 34 (Level 5)**

**Câu hỏi:** Identify 'binge-watching' sessions, defined as a customer renting 3 or more films within any 24-hour period, and list the customer and films.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH RentalSessions AS (SELECT customer_id, film_id, rental_date, COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as session_id FROM (SELECT r.customer_id, i.film_id, r.rental_date, r.rental_date - LAG(r.rental_date, 1, r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date) as time_diff FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id) as diffs WHERE time_diff > '24 hours'), BingeSessions AS (SELECT session_id, customer_id, COUNT(film_id) as binge_count FROM RentalSessions GROUP BY session_id, customer_id HAVING COUNT(film_id) >= 3) SELECT c.first_name, c.last_name, bs.binge_count, STRING_AGG(f.title, ', ') as binged_films FROM BingeSessions bs JOIN RentalSessions rs ON bs.session_id = rs.session_id AND bs.customer_id = rs.customer_id JOIN customer c ON bs.customer_id = c.customer_id JOIN film f ON rs.film_id = f.film_id GROUP BY c.first_name, c.last_name, bs.binge_count;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 35 (Level 5)**

**Câu hỏi:** Xác định các 'phiên xem liên tục', được định nghĩa là một khách hàng thuê 3 phim trở lên trong bất kỳ khoảng thời gian 24 giờ nào, và liệt kê khách hàng và các phim đó.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH PhienThue AS (SELECT customer_id, film_id, rental_date, COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as phien_id FROM (SELECT r.customer_id, i.film_id, r.rental_date, r.rental_date - LAG(r.rental_date, 1, r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date) as khoang_cach_tg FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id) as khoang_cach WHERE khoang_cach_tg > '24 hours'), PhienXemLienTuc AS (SELECT phien_id, customer_id, COUNT(film_id) as so_phim_xem FROM PhienThue GROUP BY phien_id, customer_id HAVING COUNT(film_id) >= 3) SELECT c.first_name, c.last_name, pxlt.so_phim_xem, STRING_AGG(f.title, ', ') as cac_phim_da_xem FROM PhienXemLienTuc pxlt JOIN PhienThue pt ON pxlt.phien_id = pt.phien_id AND pxlt.customer_id = pt.customer_id JOIN customer c ON pxlt.customer_id = c.customer_id JOIN film f ON pt.film_id = f.film_id GROUP BY c.first_name, c.last_name, pxlt.so_phim_xem;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM inventory;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 36 (Level 5)**

**Câu hỏi:** For customers who rented 'AGENT TRUMAN', what other film did they rent most frequently?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH AgentTrumanRenters AS (SELECT DISTINCT r.customer_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE f.title = 'AGENT TRUMAN') SELECT f.title, COUNT(*) as rental_count FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE r.customer_id IN (SELECT customer_id FROM AgentTrumanRenters) AND f.title <> 'AGENT TRUMAN' GROUP BY f.title ORDER BY rental_count DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 37 (Level 5)**

**Câu hỏi:** Đối với những khách hàng đã thuê 'AGENT TRUMAN', họ đã thuê phim nào khác thường xuyên nhất?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH NguoiThueAgentTruman AS (SELECT DISTINCT r.customer_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE f.title = 'AGENT TRUMAN') SELECT f.title, COUNT(*) as so_luot_thue FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE r.customer_id IN (SELECT customer_id FROM NguoiThueAgentTruman) AND f.title <> 'AGENT TRUMAN' GROUP BY f.title ORDER BY so_luot_thue DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT title FROM film LIMIT 5;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 38 (Level 5)**

**Câu hỏi:** Identify overstocked films: films with more than 7 copies in inventory that have not been rented in the last 6 months.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH LastRental AS (SELECT i.film_id, MAX(r.rental_date) as last_rental_date FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id GROUP BY i.film_id), InventoryCount AS (SELECT film_id, COUNT(*) as copy_count FROM inventory GROUP BY film_id) SELECT f.title, ic.copy_count, lr.last_rental_date FROM film f JOIN InventoryCount ic ON f.film_id = ic.film_id LEFT JOIN LastRental lr ON f.film_id = lr.film_id WHERE ic.copy_count > 7 AND (lr.last_rental_date IS NULL OR lr.last_rental_date < NOW() - INTERVAL '6 months');
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM inventory;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 39 (Level 5)**

**Câu hỏi:** Xác định các phim tồn kho quá nhiều: phim có hơn 7 bản sao trong kho mà không được thuê trong 6 tháng qua.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.1/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH ThueCuoi AS (SELECT i.film_id, MAX(r.rental_date) as ngay_thue_cuoi FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id GROUP BY i.film_id), DemTonKho AS (SELECT film_id, COUNT(*) as so_ban_sao FROM inventory GROUP BY film_id) SELECT f.title, dtk.so_ban_sao, tc.ngay_thue_cuoi FROM film f JOIN DemTonKho dtk ON f.film_id = dtk.film_id LEFT JOIN ThueCuoi tc ON f.film_id = tc.film_id WHERE dtk.so_ban_sao > 7 AND (tc.ngay_thue_cuoi IS NULL OR tc.ngay_thue_cuoi < NOW() - INTERVAL '6 months');
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM inventory;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

## 💡 **KẾT LUẬN VÀ KHUYẾN NGHỊ**

### 🎯 **Đánh giá tổng thể: Kém (6.8/100)**

### ✅ **Điểm mạnh:**
- Code Quality cao (13.1/15) - GPT-4 tạo ra SQL syntax sạch và secure
- SQL Generation Rate: 100% - Luôn tạo ra được SQL query
- Best Practices tuân thủ tốt

### ❌ **Điểm yếu:**
- Correctness thấp (6.7/40) - Nhiều query không cho kết quả đúng
- Cost Efficiency kém (3.1/20) - Query không được tối ưu
- Performance chưa hiệu quả (5.9/25)

### 🔧 **Khuyến nghị cải thiện:**

1. **Cho GPT-4:**
   - Cần training thêm về PostgreSQL-specific syntax
   - Cải thiện logic reasoning cho complex queries
   - Tối ưu hóa query performance và cost

2. **Cho hệ thống:**
   - Implement query validation trước khi execution
   - Thêm query optimization hints
   - Sử dụng query plan analysis để cải thiện

3. **Use cases phù hợp:**
   - ✅ Basic queries (Level 1): 33.3% accuracy
   - ⚠️ Intermediate queries (Level 2+): Cần review và validation

---

**Báo cáo được tạo bởi Comprehensive SQL Benchmark System**  
**Dựa trên tiêu chuẩn benchmark đã định nghĩa**
