# 📊 Comprehensive SQL Benchmark Report - GPT-4 vs Expected SQL

**Thời gian tạo báo cáo:** 2025-06-24 12:39:18  
**Phương pháp đánh giá:** Execution-based comparison theo tiêu chuẩn benchmark  

---

## 🎯 **TÓM TẮT TỔNG QUAN**

| Metric | Giá trị |
|--------|---------|
| **Tổng số câu hỏi** | 48 |
| **Overall Accuracy** | **20.8%** |
| **Average Total Score** | **10.6/100** |
| **Thời gian hoàn thành** | 43.1 giây |

---

## 📋 **PHÂN TÍCH THEO TIÊU CHUẨN BENCHMARK**

### 🔍 **Score Breakdown (Weighted Scoring System)**

| Tiêu chuẩn | Trọng số | Điểm trung bình | Đánh giá |
|------------|----------|-----------------|----------|
| **Correctness** | 40% | 14.6/40 | 🔴 Kém |
| **Performance** | 25% | 8.3/25 | 🔴 Kém |
| **Cost Efficiency** | 20% | 3.3/20 | 🔴 Kém |
| **Code Quality** | 15% | 13.6/15 | 🟢 Tốt |

---

## 📊 **PHÂN BỐ ĐIỂM SỐ**

| Mức độ | Số câu | Tỷ lệ |
|--------|--------|-------|
| **Excellent (90-100)** | 0 | 0.0% |
| **Good (70-89)** | 0 | 0.0% |
| **Fair (50-69)** | 0 | 0.0% |
| **Poor (<50)** | 48 | 100.0% |

---

## 🎚️ **HIỆU SUẤT THEO TỪNG LEVEL**

### 🟢 **Level 1 (Basic)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **87.5%** |
| **Average Score** | 20.1/100 |
| **Correct Answers** | 7/8 |

### 🔴 **Level 2 (Intermediate)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **10.0%** |
| **Average Score** | 11.9/100 |
| **Correct Answers** | 1/10 |

### 🔴 **Level 3 (Advanced)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **20.0%** |
| **Average Score** | 12.5/100 |
| **Correct Answers** | 2/10 |

### 🔴 **Level 4 (Expert)**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **0.0%** |
| **Average Score** | 6.5/100 |
| **Correct Answers** | 0/10 |

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
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM film;
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
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT name FROM category;
``` |
| 4 | **Level 1**<br/>Có bao nhiêu giao dịch thanh toán đã được ghi nhận? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM payment;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 1.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(payment_id) FROM payment;
``` |
| 5 | **Level 1**<br/>How many actors are listed? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM actor;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM actor;
``` |
| 6 | **Level 1**<br/>Tổng cộng có bao nhiêu bản sao phim trong kho? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT COUNT(*) FROM inventory;
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 0.0ms, 1 rows<br/>
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
``` | **Score:** 21.6/100 ✅<br/>
**Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT first_name, last_name, email 
FROM customer;
``` |
| 8 | **Level 1**<br/>What is the highest single payment amount recorded? | **Perf:** 0.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT amount FROM payment ORDER BY amount DESC LIMIT 1;
``` | **Score:** 10.4/100 ❌<br/>
**Perf:** 2.0ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT MAX(amount) AS highest_payment
FROM payment;
``` |
| 9 | **Level 2**<br/>Show the top 5 customers by total payment amount. | **Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent FROM customer c JOIN payment p ON c.c...
``` | **Score:** 10.4/100 ❌<br/>
**Perf:** 0.0ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_payment
FROM customer
J...
``` |
| 10 | **Level 2**<br/>Liệt kê 5 khách hàng chi tiêu nhiều nhất. | **Perf:** 13.2ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS tong_chi_tieu FROM customer c JOIN payment p ON c...
``` | **Score:** 12.6/100 ❌<br/>
**Perf:** 15.8ms, 5 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOI...
``` |
| 11 | **Level 2**<br/>List each customer and the total number of films they have rented. | **Perf:** 9.6ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count FROM customer c JOIN rental r O...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 4.6ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_films_rented
FROM c...
``` |
| 12 | **Level 2**<br/>Liệt kê mỗi khách hàng và tổng số phim họ đã thuê. | **Perf:** 13.4ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS so_luong_thue FROM customer c JOIN rental r ...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 4.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) as total_rented_films
FROM c...
``` |
| 13 | **Level 2**<br/>How many films are in each category? | **Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name, COUNT(fc.film_id) AS number_of_films FROM category c JOIN film_category fc ON c.categ...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category c
JOIN film_category f...
``` |
| 14 | **Level 2**<br/>Có bao nhiêu bộ phim trong mỗi thể loại? | **Perf:** 0.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name, COUNT(fc.film_id) AS so_luong_phim FROM category c JOIN film_category fc ON c.categor...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 1.0ms, 16 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category c
JOIN film_category f...
``` |
| 15 | **Level 2**<br/>List the number of copies for each film title in the inventory. | **Perf:** 0.0ms, 958 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT f.title, COUNT(i.inventory_id) AS number_of_copies FROM film f JOIN inventory i ON f.film_id ...
``` | **Score:** 21.5/100 ✅<br/>
**Perf:** 1.4ms, 958 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT f.title, COUNT(i.inventory_id) as number_of_copies
FROM film f
JOIN inventory i ON f.film_id ...
``` |
| 16 | **Level 2**<br/>Liệt kê số lượng bản sao cho mỗi tựa phim trong kho. | **Perf:** 0.0ms, 958 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT f.title, COUNT(i.inventory_id) AS so_luong_ban_sao FROM film f JOIN inventory i ON f.film_id ...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 2.0ms, 958 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT film.title, COUNT(inventory.film_id) AS number_of_copies
FROM film
JOIN inventory ON film.fil...
``` |
| 17 | **Level 2**<br/>What is the total revenue generated by each staff member? | **Perf:** 4.1ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_revenue FROM staff s JOIN payment p ON s.st...
``` | **Score:** 12.5/100 ❌<br/>
**Perf:** 5.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS total_revenue
FROM ...
``` |
| 18 | **Level 2**<br/>Tổng doanh thu do mỗi nhân viên tạo ra là bao nhiêu? | **Perf:** 0.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS tong_doanh_thu FROM staff s JOIN payment p ON s.s...
``` | **Score:** 10.3/100 ❌<br/>
**Perf:** 4.0ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) as total_revenue
FROM ...
``` |
| 19 | **Level 3**<br/>Tìm 3 thể loại hàng đầu theo tổng doanh thu. | **Perf:** 1.0ms, 3 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.name, SUM(p.amount) AS tong_doanh_thu FROM payment p JOIN rental r ON p.rental_id = r.renta...
``` | **Score:** 14.1/100 ❌<br/>
**Perf:** 16.1ms, 3 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT c.name AS category_name, SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc...
``` |
| 20 | **Level 3**<br/>Những khách hàng nào chỉ thuê những phim được xếp hạng 'G'? | **Perf:** 12.6ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id JOIN...
``` | **Score:** 22.5/100 ✅<br/>
**Perf:** 8.9ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.custome...
``` |
| 21 | **Level 3**<br/>List actors who have worked in both 'Comedy' and 'Horror' films. | **Perf:** 2.4ms, 115 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 23.4/100 ✅<br/>
**Perf:** 2.7ms, 115 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN fi...
``` |
| 22 | **Level 3**<br/>Liệt kê các diễn viên đã đóng cả phim 'Hài' và 'Kinh dị'. | **Perf:** 0.0ms, 115 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 7.3/100 ❌<br/>
**Perf:** 1.0ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN fi...
``` |
| 23 | **Level 3**<br/>What is the average time between rentals for each customer? | **Perf:** 15.8ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT customer_id, AVG(rental_gap) AS avg_days_between_rentals FROM (SELECT customer_id, rental_dat...
``` | **Score:** 10.9/100 ❌<br/>
**Perf:** 9.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer_id, AVG(rental_duration) AS average_rental_duration
FROM rental
INNER JOIN inventory...
``` |
| 24 | **Level 3**<br/>Thời gian trung bình giữa các lần thuê của mỗi khách hàng là bao nhiêu? | **Perf:** 15.2ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT customer_id, AVG(khoang_cach_thue) AS so_ngay_thue_trung_binh FROM (SELECT customer_id, renta...
``` | **Score:** 12.9/100 ❌<br/>
**Perf:** 21.4ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer_id, AVG(rental_duration) AS average_rental_duration
FROM (
    SELECT customer_id, r...
``` |
| 25 | **Level 3**<br/>List films that are in stock at store 1 but not at store 2. | **Perf:** 2.4ms, 196 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SEL...
``` | **Score:** 7.4/100 ❌<br/>
**Perf:** 1.0ms, 576 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
AND f.film...
``` |
| 26 | **Level 3**<br/>Liệt kê các phim có trong kho tại cửa hàng 1 nhưng không có tại cửa hàng 2. | **Perf:** 2.4ms, 196 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SEL...
``` | **Score:** 7.4/100 ❌<br/>
**Perf:** 1.0ms, 576 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
AND f.film...
``` |
| 27 | **Level 3**<br/>What is the total revenue per day of the week? | **Perf:** 12.9ms, 7 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT EXTRACT(DOW FROM payment_date) AS day_of_week, TO_CHAR(payment_date, 'Day') AS day_name, SUM(...
``` | **Score:** 10.6/100 ❌<br/>
**Perf:** 6.7ms, 7 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT 
    TO_CHAR(payment_date, 'Day') AS day_of_week, 
    SUM(amount) AS total_revenue
FROM 
   ...
``` |
| 28 | **Level 3**<br/>Tổng doanh thu mỗi ngày trong tuần là bao nhiêu? | **Perf:** 4.0ms, 7 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT EXTRACT(DOW FROM payment_date) AS ngay_trong_tuan_so, TO_CHAR(payment_date, 'Day') AS ten_nga...
``` | **Score:** 8.3/100 ❌<br/>
**Perf:** 4.0ms, 32 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT DATE(payment_date) AS date, SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE(payment_d...
``` |
| 29 | **Level 4**<br/>Liệt kê các phim đã được thuê từ cả hai cửa hàng. | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 3.8/100 ❌<br/>
**Perf:** 11.0ms, 958 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inv...
``` |
| 30 | **Level 4**<br/>Identify 'loyal' customers who have rented in at least 3 different months. | **Perf:** 14.2ms, 598 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROU...
``` | **Score:** 11.0/100 ❌<br/>
**Perf:** 8.3ms, 598 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_i...
``` |
| 31 | **Level 4**<br/>Xác định những khách hàng 'trung thành' đã thuê trong ít nhất 3 tháng khác nhau. | **Perf:** 14.1ms, 598 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROU...
``` | ❌ **Error:** column "month" does not exist
LINE 9:         HAVI... |
| 32 | **Level 4**<br/>What is the total revenue from the top 10% of customers by spending? | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... |
| 33 | **Level 4**<br/>Tổng doanh thu từ 10% khách hàng chi tiêu nhiều nhất là bao nhiêu? | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | ❌ **Error:** column "amount" does not exist
LINE 1: ...(ANALYZE... |
| 34 | **Level 4**<br/>For each staff member, show their total number of transactions (rentals and paym... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.2/100 ❌<br/>
**Perf:** 15.7ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, 
       (SELECT COUNT(*) FROM rental WHERE...
``` |
| 35 | **Level 4**<br/>Đối với mỗi nhân viên, hãy hiển thị tổng số giao dịch của họ (lượt thuê và thanh... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.1/100 ❌<br/>
**Perf:** 16856.7ms, 2 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, COUNT(rental.rental_id) AS total_rentals, ...
``` |
| 36 | **Level 4**<br/>List actors who have appeared in at least one film in every available rating cat... | **Perf:** 12.1ms, 196 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 7.5/100 ❌<br/>
**Perf:** 2.0ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT r.rating
    FROM film r...
``` |
| 37 | **Level 4**<br/>Liệt kê các diễn viên đã xuất hiện trong ít nhất một phim ở mọi hạng mục xếp hạn... | **Perf:** 0.0ms, 196 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN fi...
``` | **Score:** 7.4/100 ❌<br/>
**Perf:** 10.3ms, 195 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_i...
``` |
| 38 | **Level 4**<br/>What is the average number of payments per day? | **Perf:** 2.1ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT AVG(payment_count) FROM (SELECT CAST(payment_date AS DATE), COUNT(payment_id) as payment_coun...
``` | **Score:** 13.9/100 ❌<br/>
**Perf:** 10.4ms, 1 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT AVG(payment_count) AS average_payments_per_day
FROM (
    SELECT COUNT(payment_id) AS payment...
``` |
| 39 | **Level 5**<br/>Perform a cohort analysis to track the monthly retention rate of customers based... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... |
| 40 | **Level 5**<br/>Thực hiện phân tích cohort để theo dõi tỷ lệ giữ chân khách hàng hàng tháng dựa ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... |
| 41 | **Level 5**<br/>Calculate the Customer Lifetime Value (LTV) for each customer, defined as their ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.2/100 ❌<br/>
**Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT customer_id, SUM(amount) AS total_spending, 
        RANK() OVER (ORDER BY SUM(amount) DESC) ...
``` |
| 42 | **Level 5**<br/>Tính Giá trị Vòng đời Khách hàng (LTV) cho mỗi khách hàng, được định nghĩa là tổ... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.2/100 ❌<br/>
**Perf:** 0.0ms, 599 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 10/10<br/>
```sql
SELECT 
    customer_id, 
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC...
``` |
| 43 | **Level 5**<br/>Identify 'binge-watching' sessions, defined as a customer renting 3 or more film... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 3.9/100 ❌<br/>
**Perf:** 208.4ms, 3247 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT c.customer_id, c.first_name, c.last_name, f.film_id, f.title
FROM customer c
JOIN rental r ON...
``` |
| 44 | **Level 5**<br/>Xác định các 'phiên xem liên tục', được định nghĩa là một khách hàng thuê 3 phim... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 3.9/100 ❌<br/>
**Perf:** 205.2ms, 3247 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 8/10<br/>
```sql
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    f.film_id, 
    f.title, 
    r...
``` |
| 45 | **Level 5**<br/>For customers who rented 'AGENT TRUMAN', what other film did they rent most freq... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 1.0ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT film.title, COUNT(*) as rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inve...
``` |
| 46 | **Level 5**<br/>Đối với những khách hàng đã thuê 'AGENT TRUMAN', họ đã thuê phim nào khác thường... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 0.0ms, 0 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT title, COUNT(*) as rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN re...
``` |
| 47 | **Level 5**<br/>Identify overstocked films: films with more than 7 copies in inventory that have... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 9.2ms, 72 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT film.film_id, film.title, COUNT(inventory.inventory_id) AS inventory_count
FROM film
JOIN inv...
``` |
| 48 | **Level 5**<br/>Xác định các phim tồn kho quá nhiều: phim có hơn 7 bản sao trong kho mà không đư... | ❌ **Error:** Chỉ cho phép câu lệnh SELECT... | **Score:** 4.0/100 ❌<br/>
**Perf:** 13.9ms, 872 rows<br/>
**Cost:** 0.0, 0 examined<br/>
**Quality:** 9/10<br/>
```sql
SELECT film.title, COUNT(inventory.inventory_id) AS inventory_count
FROM film
JOIN inventory ON film...
``` |

---

## 📝 **CHI TIẾT TỪNG CÂU HỎI**

### ✅ **Câu 1 (Level 1)**

**Câu hỏi:** Có bao nhiêu bộ phim trong cơ sở dữ liệu?

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
SELECT COUNT(*) FROM film;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM film;
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

### ✅ **Câu 3 (Level 1)**

**Câu hỏi:** Liệt kê tên tất cả các thể loại phim.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 16 | 16 |
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
SELECT name FROM category ORDER BY name ASC;
```

**Generated SQL:**
```sql
SELECT name FROM category;
```

---

### ✅ **Câu 4 (Level 1)**

**Câu hỏi:** Có bao nhiêu giao dịch thanh toán đã được ghi nhận?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.97ms |
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
SELECT COUNT(*) FROM payment;
```

**Generated SQL:**
```sql
SELECT COUNT(payment_id) FROM payment;
```

---

### ✅ **Câu 5 (Level 1)**

**Câu hỏi:** How many actors are listed?

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
SELECT COUNT(*) FROM actor;
```

**Generated SQL:**
```sql
SELECT COUNT(*) FROM actor;
```

---

### ✅ **Câu 6 (Level 1)**

**Câu hỏi:** Tổng cộng có bao nhiêu bản sao phim trong kho?

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
- 📝 **Code Quality:** 13.9/15
- 🏆 **Total Score:** **21.6/100**

**Expected SQL:**
```sql
SELECT first_name, last_name, email FROM customer;
```

**Generated SQL:**
```sql
SELECT first_name, last_name, email 
FROM customer;
```

---

### ❌ **Câu 8 (Level 1)**

**Câu hỏi:** What is the highest single payment amount recorded?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.99ms |
| **Rows Returned** | 1 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **10.4/100**

**Expected SQL:**
```sql
SELECT amount FROM payment ORDER BY amount DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT MAX(amount) AS highest_payment
FROM payment;
```

---

### ❌ **Câu 9 (Level 2)**

**Câu hỏi:** Show the top 5 customers by total payment amount.

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
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **10.4/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_spent DESC LIMIT 5;
```

**Generated SQL:**
```sql
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_payment
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY total_payment DESC
LIMIT 5;
```

---

### ❌ **Câu 10 (Level 2)**

**Câu hỏi:** Liệt kê 5 khách hàng chi tiêu nhiều nhất.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 13.21ms | 15.84ms |
| **Rows Returned** | 5 | 5 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 18.7/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **12.6/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, SUM(p.amount) AS tong_chi_tieu FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY tong_chi_tieu DESC LIMIT 5;
```

**Generated SQL:**
```sql
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_spent
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

---

### ❌ **Câu 11 (Level 2)**

**Câu hỏi:** List each customer and the total number of films they have rented.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 9.62ms | 4.65ms |
| **Rows Returned** | 599 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY rental_count DESC;
```

**Generated SQL:**
```sql
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS total_films_rented
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;
```

---

### ❌ **Câu 12 (Level 2)**

**Câu hỏi:** Liệt kê mỗi khách hàng và tổng số phim họ đã thuê.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 13.35ms | 4.04ms |
| **Rows Returned** | 599 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS so_luong_thue FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY so_luong_thue DESC;
```

**Generated SQL:**
```sql
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) as total_rented_films
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;
```

---

### ❌ **Câu 13 (Level 2)**

**Câu hỏi:** How many films are in each category?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 16 | 16 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT c.name, COUNT(fc.film_id) AS number_of_films FROM category c JOIN film_category fc ON c.category_id = fc.category_id GROUP BY c.name ORDER BY number_of_films DESC;
```

**Generated SQL:**
```sql
SELECT c.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;
```

---

### ❌ **Câu 14 (Level 2)**

**Câu hỏi:** Có bao nhiêu bộ phim trong mỗi thể loại?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.01ms |
| **Rows Returned** | 16 | 16 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT c.name, COUNT(fc.film_id) AS so_luong_phim FROM category c JOIN film_category fc ON c.category_id = fc.category_id GROUP BY c.name ORDER BY so_luong_phim DESC;
```

**Generated SQL:**
```sql
SELECT c.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;
```

---

### ✅ **Câu 15 (Level 2)**

**Câu hỏi:** List the number of copies for each film title in the inventory.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.35ms |
| **Rows Returned** | 958 | 958 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **21.5/100**

**Expected SQL:**
```sql
SELECT f.title, COUNT(i.inventory_id) AS number_of_copies FROM film f JOIN inventory i ON f.film_id = i.film_id GROUP BY f.title ORDER BY number_of_copies DESC;
```

**Generated SQL:**
```sql
SELECT f.title, COUNT(i.inventory_id) as number_of_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;
```

---

### ❌ **Câu 16 (Level 2)**

**Câu hỏi:** Liệt kê số lượng bản sao cho mỗi tựa phim trong kho.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 2.00ms |
| **Rows Returned** | 958 | 958 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT f.title, COUNT(i.inventory_id) AS so_luong_ban_sao FROM film f JOIN inventory i ON f.film_id = i.film_id GROUP BY f.title ORDER BY so_luong_ban_sao DESC;
```

**Generated SQL:**
```sql
SELECT film.title, COUNT(inventory.film_id) AS number_of_copies
FROM film
JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film.title;
```

---

### ❌ **Câu 17 (Level 2)**

**Câu hỏi:** What is the total revenue generated by each staff member?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 4.15ms | 5.00ms |
| **Rows Returned** | 2 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 18.8/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **12.5/100**

**Expected SQL:**
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_revenue FROM staff s JOIN payment p ON s.staff_id = p.staff_id GROUP BY s.staff_id, s.first_name, s.last_name ORDER BY total_revenue DESC;
```

**Generated SQL:**
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS total_revenue
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id, staff.first_name, staff.last_name;
```

---

### ❌ **Câu 18 (Level 2)**

**Câu hỏi:** Tổng doanh thu do mỗi nhân viên tạo ra là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 4.03ms |
| **Rows Returned** | 2 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **10.3/100**

**Expected SQL:**
```sql
SELECT s.first_name, s.last_name, SUM(p.amount) AS tong_doanh_thu FROM staff s JOIN payment p ON s.staff_id = p.staff_id GROUP BY s.staff_id, s.first_name, s.last_name ORDER BY tong_doanh_thu DESC;
```

**Generated SQL:**
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) as total_revenue
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id, staff.first_name, staff.last_name;
```

---

### ❌ **Câu 19 (Level 3)**

**Câu hỏi:** Tìm 3 thể loại hàng đầu theo tổng doanh thu.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 1.01ms | 16.15ms |
| **Rows Returned** | 3 | 3 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 24.5/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **14.1/100**

**Expected SQL:**
```sql
SELECT c.name, SUM(p.amount) AS tong_doanh_thu FROM payment p JOIN rental r ON p.rental_id = r.rental_id JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film_category fc ON i.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id GROUP BY c.name ORDER BY tong_doanh_thu DESC LIMIT 3;
```

**Generated SQL:**
```sql
SELECT c.name AS category_name, SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 3;
```

---

### ✅ **Câu 20 (Level 3)**

**Câu hỏi:** Những khách hàng nào chỉ thuê những phim được xếp hạng 'G'?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 12.59ms | 8.94ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 14.4/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.4/15
- 🏆 **Total Score:** **22.5/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id GROUP BY c.customer_id HAVING MAX(f.rating) = 'G' AND MIN(f.rating) = 'G';
```

**Generated SQL:**
```sql
SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.rating = 'G'
AND c.customer_id NOT IN (
    SELECT DISTINCT c.customer_id
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE f.rating <> 'G'
);
```

---

### ✅ **Câu 21 (Level 3)**

**Câu hỏi:** List actors who have worked in both 'Comedy' and 'Horror' films.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 2.43ms | 2.69ms |
| **Rows Returned** | 115 | 115 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 40.0/40
- ⚡ **Performance:** 18.2/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.0/15
- 🏆 **Total Score:** **23.4/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Comedy' INTERSECT SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Horror';
```

**Generated SQL:**
```sql
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ('Comedy', 'Horror')
GROUP BY a.first_name, a.last_name
HAVING COUNT(DISTINCT c.name) = 2;
```

---

### ❌ **Câu 22 (Level 3)**

**Câu hỏi:** Liệt kê các diễn viên đã đóng cả phim 'Hài' và 'Kinh dị'.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 1.00ms |
| **Rows Returned** | 115 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.0/15
- 🏆 **Total Score:** **7.3/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Comedy' INTERSECT SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film_category fc ON fa.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id WHERE c.name = 'Horror';
```

**Generated SQL:**
```sql
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ('Hài', 'Kinh dị')
GROUP BY a.first_name, a.last_name
HAVING COUNT(DISTINCT c.name) = 2;
```

---

### ❌ **Câu 23 (Level 3)**

**Câu hỏi:** What is the average time between rentals for each customer?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 15.79ms | 9.01ms |
| **Rows Returned** | 599 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 11.9/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **10.9/100**

**Expected SQL:**
```sql
SELECT customer_id, AVG(rental_gap) AS avg_days_between_rentals FROM (SELECT customer_id, rental_date, LAG(rental_date, 1) OVER (PARTITION BY customer_id ORDER BY rental_date) as previous_rental_date, rental_date - LAG(rental_date, 1) OVER (PARTITION BY customer_id ORDER BY rental_date) as rental_gap FROM rental) as rental_gaps WHERE previous_rental_date IS NOT NULL GROUP BY customer_id;
```

**Generated SQL:**
```sql
SELECT customer_id, AVG(rental_duration) AS average_rental_duration
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY customer_id;
```

---

### ❌ **Câu 24 (Level 3)**

**Câu hỏi:** Thời gian trung bình giữa các lần thuê của mỗi khách hàng là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 15.17ms | 21.43ms |
| **Rows Returned** | 599 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 19.7/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **12.9/100**

**Expected SQL:**
```sql
SELECT customer_id, AVG(khoang_cach_thue) AS so_ngay_thue_trung_binh FROM (SELECT customer_id, rental_date, LAG(rental_date, 1) OVER (PARTITION BY customer_id ORDER BY rental_date) as ngay_thue_truoc, rental_date - LAG(rental_date, 1) OVER (PARTITION BY customer_id ORDER BY rental_date) as khoang_cach_thue FROM rental) as khoang_cach WHERE ngay_thue_truoc IS NOT NULL GROUP BY customer_id;
```

**Generated SQL:**
```sql
SELECT customer_id, AVG(rental_duration) AS average_rental_duration
FROM (
    SELECT customer_id, rental_date, 
    LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS previous_rental_date,
    EXTRACT(DAY FROM rental_date - LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS rental_duration
    FROM rental
) AS rental_duration
GROUP BY customer_id;
```

---

### ❌ **Câu 25 (Level 3)**

**Câu hỏi:** List films that are in stock at store 1 but not at store 2.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 2.35ms | 1.00ms |
| **Rows Returned** | 196 | 576 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.7/15
- 🏆 **Total Score:** **7.4/100**

**Expected SQL:**
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 2;
```

**Generated SQL:**
```sql
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
AND f.film_id NOT IN (
    SELECT f.film_id
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    WHERE i.store_id = 2
);
```

---

### ❌ **Câu 26 (Level 3)**

**Câu hỏi:** Liệt kê các phim có trong kho tại cửa hàng 1 nhưng không có tại cửa hàng 2.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 2.40ms | 1.00ms |
| **Rows Returned** | 196 | 576 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.7/15
- 🏆 **Total Score:** **7.4/100**

**Expected SQL:**
```sql
SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 1 EXCEPT SELECT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id WHERE i.store_id = 2;
```

**Generated SQL:**
```sql
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
AND f.film_id NOT IN (
    SELECT f.film_id
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    WHERE i.store_id = 2
);
```

---

### ❌ **Câu 27 (Level 3)**

**Câu hỏi:** What is the total revenue per day of the week?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 12.86ms | 6.72ms |
| **Rows Returned** | 7 | 7 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 10.6/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.4/15
- 🏆 **Total Score:** **10.6/100**

**Expected SQL:**
```sql
SELECT EXTRACT(DOW FROM payment_date) AS day_of_week, TO_CHAR(payment_date, 'Day') AS day_name, SUM(amount) AS total_revenue FROM payment GROUP BY day_of_week, day_name ORDER BY day_of_week;
```

**Generated SQL:**
```sql
SELECT 
    TO_CHAR(payment_date, 'Day') AS day_of_week, 
    SUM(amount) AS total_revenue
FROM 
    payment
GROUP BY 
    TO_CHAR(payment_date, 'Day');
```

---

### ❌ **Câu 28 (Level 3)**

**Câu hỏi:** Tổng doanh thu mỗi ngày trong tuần là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 3.97ms | 3.97ms |
| **Rows Returned** | 7 | 32 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 2.0/40
- ⚡ **Performance:** 17.5/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **8.3/100**

**Expected SQL:**
```sql
SELECT EXTRACT(DOW FROM payment_date) AS ngay_trong_tuan_so, TO_CHAR(payment_date, 'Day') AS ten_ngay, SUM(amount) AS tong_doanh_thu FROM payment GROUP BY ngay_trong_tuan_so, ten_ngay ORDER BY ngay_trong_tuan_so;
```

**Generated SQL:**
```sql
SELECT DATE(payment_date) AS date, SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE(payment_date)
ORDER BY DATE(payment_date);
```

---

### ❌ **Câu 29 (Level 4)**

**Câu hỏi:** Liệt kê các phim đã được thuê từ cả hai cửa hàng.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 10.97ms |
| **Rows Returned** | 0 | 958 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 12.3/15
- 🏆 **Total Score:** **3.8/100**

**Expected SQL:**
```sql
WITH ThueCH1 AS (SELECT DISTINCT i.film_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id WHERE i.store_id = 1), ThueCH2 AS (SELECT DISTINCT i.film_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id WHERE i.store_id = 2) SELECT f.title FROM film f WHERE f.film_id IN (SELECT film_id FROM ThueCH1) AND f.film_id IN (SELECT film_id FROM ThueCH2);
```

**Generated SQL:**
```sql
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE i.store_id IN (SELECT store_id FROM store);
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 30 (Level 4)**

**Câu hỏi:** Identify 'loyal' customers who have rented in at least 3 different months.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 14.19ms | 8.28ms |
| **Rows Returned** | 598 | 598 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 12.2/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **11.0/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT DATE_TRUNC('month', r.rental_date)) >= 3;
```

**Generated SQL:**
```sql
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id, COUNT(DISTINCT(EXTRACT(MONTH FROM rental_date))) as month_count
        FROM rental
        GROUP BY customer_id
    ) as subquery
    WHERE month_count >= 3
);
```

---

### ❌ **Câu 31 (Level 4)**

**Câu hỏi:** Xác định những khách hàng 'trung thành' đã thuê trong ít nhất 3 tháng khác nhau.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ❌ |
| **Execution Time** | 14.08ms | 0.00ms |
| **Rows Returned** | 598 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT DATE_TRUNC('month', r.rental_date)) >= 3;
```

**Generated SQL:**
```sql
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id, EXTRACT(MONTH FROM rental_date) AS month, EXTRACT(YEAR FROM rental_date) AS year
        FROM rental
        GROUP BY customer_id, month, year
        HAVING COUNT(DISTINCT month) >= 3
    ) AS loyal_customers
);
```

**Errors:**
- Generated: column "month" does not exist
LINE 9:         HAVING COUNT(DISTINCT month) >= 3
                                      ^


---

### ❌ **Câu 32 (Level 4)**

**Câu hỏi:** What is the total revenue from the top 10% of customers by spending?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ❌ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
WITH CustomerSpending AS (SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id), TopCustomers AS (SELECT customer_id FROM CustomerSpending ORDER BY total_spent DESC LIMIT (SELECT COUNT(*) / 10 FROM customer)) SELECT SUM(p.amount) FROM payment p WHERE p.customer_id IN (SELECT customer_id FROM TopCustomers);
```

**Generated SQL:**
```sql
WITH customer_spending AS (
            SELECT customer_id, SUM(amount) AS total_spending
            FROM payment
            GROUP BY customer_id
        ),
        top_customers AS (
            SELECT customer_id
            FROM customer_spending
            ORDER BY total_spending DESC
            LIMIT (SELECT COUNT(*) FROM customer) * 0.1
        )
        SELECT SUM(amount) AS total_revenue
        FROM payment
        WHERE customer_id IN (SELECT customer_id FROM top_customers);
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT
- Generated: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 33 (Level 4)**

**Câu hỏi:** Tổng doanh thu từ 10% khách hàng chi tiêu nhiều nhất là bao nhiêu?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ❌ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
WITH ChiTieuKH AS (SELECT customer_id, SUM(amount) AS tong_chi FROM payment GROUP BY customer_id), TopKH AS (SELECT customer_id FROM ChiTieuKH ORDER BY tong_chi DESC LIMIT (SELECT COUNT(*) / 10 FROM customer)) SELECT SUM(p.amount) FROM payment p WHERE p.customer_id IN (SELECT customer_id FROM TopKH);
```

**Generated SQL:**
```sql
SELECT SUM(amount) AS total_revenue
FROM (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
    ORDER BY total_amount DESC
    LIMIT (SELECT COUNT(*) FROM customer) * 0.1
) AS top_customers;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT
- Generated: column "amount" does not exist
LINE 1: ...(ANALYZE, BUFFERS, COSTS, FORMAT JSON) SELECT SUM(amount) AS...
                                                             ^


---

### ❌ **Câu 34 (Level 4)**

**Câu hỏi:** For each staff member, show their total number of transactions (rentals and payments).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 15.65ms |
| **Rows Returned** | 0 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
WITH RentalCounts AS (SELECT staff_id, COUNT(*) as rental_count FROM rental GROUP BY staff_id), PaymentCounts AS (SELECT staff_id, COUNT(*) as payment_count FROM payment GROUP BY staff_id) SELECT s.first_name, s.last_name, rc.rental_count, pc.payment_count FROM staff s JOIN RentalCounts rc ON s.staff_id = rc.staff_id JOIN PaymentCounts pc ON s.staff_id = pc.staff_id;
```

**Generated SQL:**
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, 
       (SELECT COUNT(*) FROM rental WHERE rental.staff_id = staff.staff_id) AS rental_transactions,
       (SELECT COUNT(*) FROM payment WHERE payment.staff_id = staff.staff_id) AS payment_transactions,
       ((SELECT COUNT(*) FROM rental WHERE rental.staff_id = staff.staff_id) + 
       (SELECT COUNT(*) FROM payment WHERE payment.staff_id = staff.staff_id)) AS total_transactions
FROM staff;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 35 (Level 4)**

**Câu hỏi:** Đối với mỗi nhân viên, hãy hiển thị tổng số giao dịch của họ (lượt thuê và thanh toán).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 16856.69ms |
| **Rows Returned** | 0 | 2 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.3/15
- 🏆 **Total Score:** **4.1/100**

**Expected SQL:**
```sql
WITH DemThue AS (SELECT staff_id, COUNT(*) as so_luong_thue FROM rental GROUP BY staff_id), DemThanhToan AS (SELECT staff_id, COUNT(*) as so_luong_tt FROM payment GROUP BY staff_id) SELECT s.first_name, s.last_name, dt.so_luong_thue, dtt.so_luong_tt FROM staff s JOIN DemThue dt ON s.staff_id = dt.staff_id JOIN DemThanhToan dtt ON s.staff_id = dtt.staff_id;
```

**Generated SQL:**
```sql
SELECT staff.staff_id, staff.first_name, staff.last_name, COUNT(rental.rental_id) AS total_rentals, COUNT(payment.payment_id) AS total_payments
FROM staff
LEFT JOIN rental ON staff.staff_id = rental.staff_id
LEFT JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 36 (Level 4)**

**Câu hỏi:** List actors who have appeared in at least one film in every available rating category (G, PG, PG-13, R, NC-17).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 12.07ms | 2.00ms |
| **Rows Returned** | 196 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 13.5/15
- 🏆 **Total Score:** **7.5/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film f ON fa.film_id = f.film_id GROUP BY a.actor_id, a.first_name, a.last_name HAVING COUNT(DISTINCT f.rating) = (SELECT COUNT(DISTINCT rating) FROM film);
```

**Generated SQL:**
```sql
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT r.rating
    FROM film r
    WHERE NOT EXISTS (
        SELECT fa.film_id
        FROM film_actor fa
        WHERE fa.actor_id = a.actor_id AND fa.film_id = r.film_id
    )
)
GROUP BY a.first_name, a.last_name
HAVING COUNT(DISTINCT (SELECT f.rating FROM film f WHERE f.film_id IN (SELECT fa.film_id FROM film_actor fa WHERE fa.actor_id = a.actor_id))) = (SELECT COUNT(DISTINCT rating) FROM film);
```

---

### ❌ **Câu 37 (Level 4)**

**Câu hỏi:** Liệt kê các diễn viên đã xuất hiện trong ít nhất một phim ở mọi hạng mục xếp hạng có sẵn (G, PG, PG-13, R, NC-17).

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 0.00ms | 10.26ms |
| **Rows Returned** | 196 | 195 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 10.0/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 12.4/15
- 🏆 **Total Score:** **7.4/100**

**Expected SQL:**
```sql
SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id JOIN film f ON fa.film_id = f.film_id GROUP BY a.actor_id, a.first_name, a.last_name HAVING COUNT(DISTINCT f.rating) = (SELECT COUNT(DISTINCT rating) FROM film);
```

**Generated SQL:**
```sql
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'G'
) AND a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'PG'
) AND a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'PG-13'
) AND a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'R'
) AND a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'NC-17'
);
```

---

### ❌ **Câu 38 (Level 4)**

**Câu hỏi:** What is the average number of payments per day?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ✅ | ✅ |
| **Execution Time** | 2.07ms | 10.38ms |
| **Rows Returned** | 1 | 1 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 12.0/40
- ⚡ **Performance:** 23.5/25  
- 💰 **Cost Efficiency:** 5.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **13.9/100**

**Expected SQL:**
```sql
SELECT AVG(payment_count) FROM (SELECT CAST(payment_date AS DATE), COUNT(payment_id) as payment_count FROM payment GROUP BY CAST(payment_date AS DATE)) as daily_counts;
```

**Generated SQL:**
```sql
SELECT AVG(payment_count) AS average_payments_per_day
FROM (
    SELECT COUNT(payment_id) AS payment_count
    FROM payment
    GROUP BY DATE(payment_date)
) AS daily_payments;
```

---

### ❌ **Câu 39 (Level 5)**

**Câu hỏi:** Perform a cohort analysis to track the monthly retention rate of customers based on their registration month.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ❌ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.0/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH customer_cohorts AS (SELECT customer_id, DATE_TRUNC('month', create_date) AS cohort_month FROM customer), rental_activity AS (SELECT customer_id, DATE_TRUNC('month', rental_date) AS rental_month FROM rental), cohort_monthly_activity AS (SELECT c.cohort_month, EXTRACT(YEAR FROM r.rental_month) * 12 + EXTRACT(MONTH FROM r.rental_month) - (EXTRACT(YEAR FROM c.cohort_month) * 12 + EXTRACT(MONTH FROM c.cohort_month)) AS month_number, COUNT(DISTINCT r.customer_id) AS active_customers FROM customer_cohorts c JOIN rental_activity r ON c.customer_id = r.customer_id GROUP BY 1, 2), cohort_size AS (SELECT cohort_month, COUNT(1) AS total_customers FROM customer_cohorts GROUP BY 1) SELECT cs.cohort_month::date, cma.month_number, cs.total_customers, cma.active_customers, (cma.active_customers::decimal * 100 / cs.total_customers) as retention_rate FROM cohort_monthly_activity cma JOIN cohort_size cs ON cma.cohort_month = cs.cohort_month WHERE cma.month_number >= 0 ORDER BY 1, 2;
```

**Generated SQL:**
```sql
WITH cohorts AS (
    SELECT 
        customer_id, 
        DATE_TRUNC('month', create_date) AS cohort_month
    FROM 
        customer
),
monthly_activity AS (
    SELECT 
        customer_id, 
        DATE_TRUNC('month', rental_date) AS activity_month
    FROM 
        rental
),
cohorts_activity AS (
    SELECT 
        c.customer_id, 
        c.cohort_month, 
        m.activity_month
    FROM 
        cohorts c
    JOIN 
        monthly_activity m ON c.customer_id = m.customer_id
),
cohorts_size AS (
    SELECT 
        cohort_month, 
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM 
        cohorts
    GROUP BY 
        cohort_month
),
retention AS (
    SELECT 
        c.cohort_month, 
        c.activity_month, 
        COUNT(DISTINCT c.customer_id) AS active_customers
    FROM 
        cohorts_activity c
    GROUP BY 
        c.cohort_month, 
        c.activity_month
)
SELECT 
    r.cohort_month, 
    r.activity_month, 
    r.active_customers::float / c.cohort_size AS retention_rate
FROM 
    retention r
JOIN 
    cohorts_size c ON r.cohort_month = c.cohort_month
ORDER BY 
    r.cohort_month, 
    r.activity_month;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT
- Generated: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 40 (Level 5)**

**Câu hỏi:** Thực hiện phân tích cohort để theo dõi tỷ lệ giữ chân khách hàng hàng tháng dựa trên tháng đăng ký của họ.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ❌ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 12.2/15
- 🏆 **Total Score:** **3.8/100**

**Expected SQL:**
```sql
WITH nhom_khach_hang AS (SELECT customer_id, DATE_TRUNC('month', create_date) AS thang_nhom FROM customer), hoat_dong_thue AS (SELECT customer_id, DATE_TRUNC('month', rental_date) AS thang_thue FROM rental), hoat_dong_nhom_thang AS (SELECT nkh.thang_nhom, EXTRACT(YEAR FROM hdt.thang_thue) * 12 + EXTRACT(MONTH FROM hdt.thang_thue) - (EXTRACT(YEAR FROM nkh.thang_nhom) * 12 + EXTRACT(MONTH FROM nkh.thang_nhom)) AS so_thang, COUNT(DISTINCT hdt.customer_id) AS kh_hoat_dong FROM nhom_khach_hang nkh JOIN hoat_dong_thue hdt ON nkh.customer_id = hdt.customer_id GROUP BY 1, 2), kich_thuoc_nhom AS (SELECT thang_nhom, COUNT(1) AS tong_khach_hang FROM nhom_khach_hang GROUP BY 1) SELECT ktn.thang_nhom::date, hdnt.so_thang, ktn.tong_khach_hang, hdnt.kh_hoat_dong, (hdnt.kh_hoat_dong::decimal * 100 / ktn.tong_khach_hang) as ty_le_giu_chan FROM hoat_dong_nhom_thang hdnt JOIN kich_thuoc_nhom ktn ON hdnt.thang_nhom = ktn.thang_nhom WHERE hdnt.so_thang >= 0 ORDER BY 1, 2;
```

**Generated SQL:**
```sql
WITH cohort AS (
    SELECT 
        customer_id, 
        DATE_TRUNC('month', create_date) AS cohort_month
    FROM 
        customer
),
activity AS (
    SELECT 
        customer_id, 
        DATE_TRUNC('month', rental_date) AS activity_month
    FROM 
        rental
),
cohort_activity AS (
    SELECT 
        cohort.customer_id, 
        cohort.cohort_month, 
        activity.activity_month
    FROM 
        cohort
    JOIN 
        activity ON cohort.customer_id = activity.customer_id
),
retention AS (
    SELECT 
        cohort_month, 
        activity_month, 
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM 
        cohort_activity
    GROUP BY 
        cohort_month, 
        activity_month
)
SELECT 
    cohort_month, 
    activity_month, 
    retained_customers * 1.0 / (SELECT COUNT(DISTINCT customer_id) FROM cohort WHERE cohort_month = retention.cohort_month) AS retention_rate
FROM 
    retention
ORDER BY 
    cohort_month, 
    activity_month;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT
- Generated: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 41 (Level 5)**

**Câu hỏi:** Calculate the Customer Lifetime Value (LTV) for each customer, defined as their total spending, and show their LTV rank.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
WITH customer_ltv AS (SELECT customer_id, SUM(amount) as ltv FROM payment GROUP BY customer_id) SELECT c.first_name, c.last_name, cl.ltv, RANK() OVER (ORDER BY cl.ltv DESC) as ltv_rank FROM customer_ltv cl JOIN customer c ON cl.customer_id = c.customer_id ORDER BY ltv_rank;
```

**Generated SQL:**
```sql
SELECT customer_id, SUM(amount) AS total_spending, 
        RANK() OVER (ORDER BY SUM(amount) DESC) AS LTV_rank
        FROM payment
        GROUP BY customer_id
        ORDER BY total_spending DESC;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 42 (Level 5)**

**Câu hỏi:** Tính Giá trị Vòng đời Khách hàng (LTV) cho mỗi khách hàng, được định nghĩa là tổng chi tiêu của họ, và hiển thị thứ hạng LTV của họ.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 599 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 14.7/15
- 🏆 **Total Score:** **4.2/100**

**Expected SQL:**
```sql
WITH ltv_khach_hang AS (SELECT customer_id, SUM(amount) as ltv FROM payment GROUP BY customer_id) SELECT c.first_name, c.last_name, lkh.ltv, RANK() OVER (ORDER BY lkh.ltv DESC) as hang_ltv FROM ltv_khach_hang lkh JOIN customer c ON lkh.customer_id = c.customer_id ORDER BY hang_ltv;
```

**Generated SQL:**
```sql
SELECT 
    customer_id, 
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS LTV_rank
FROM 
    payment
GROUP BY 
    customer_id
ORDER BY 
    total_spent DESC;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 43 (Level 5)**

**Câu hỏi:** Identify 'binge-watching' sessions, defined as a customer renting 3 or more films within any 24-hour period, and list the customer and films.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 208.45ms |
| **Rows Returned** | 0 | 3247 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 12.4/15
- 🏆 **Total Score:** **3.9/100**

**Expected SQL:**
```sql
WITH RentalSessions AS (SELECT customer_id, film_id, rental_date, COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as session_id FROM (SELECT r.customer_id, i.film_id, r.rental_date, r.rental_date - LAG(r.rental_date, 1, r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date) as time_diff FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id) as diffs WHERE time_diff > '24 hours'), BingeSessions AS (SELECT session_id, customer_id, COUNT(film_id) as binge_count FROM RentalSessions GROUP BY session_id, customer_id HAVING COUNT(film_id) >= 3) SELECT c.first_name, c.last_name, bs.binge_count, STRING_AGG(f.title, ', ') as binged_films FROM BingeSessions bs JOIN RentalSessions rs ON bs.session_id = rs.session_id AND bs.customer_id = rs.customer_id JOIN customer c ON bs.customer_id = c.customer_id JOIN film f ON rs.film_id = f.film_id GROUP BY c.first_name, c.last_name, bs.binge_count;
```

**Generated SQL:**
```sql
SELECT c.customer_id, c.first_name, c.last_name, f.film_id, f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE EXISTS (
    SELECT 1
    FROM rental r1
    WHERE r1.customer_id = c.customer_id
    AND r1.rental_date BETWEEN r.rental_date AND r.rental_date + INTERVAL '1 day'
    GROUP BY r1.customer_id
    HAVING COUNT(*) >= 3
)
ORDER BY c.customer_id, r.rental_date;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 44 (Level 5)**

**Câu hỏi:** Xác định các 'phiên xem liên tục', được định nghĩa là một khách hàng thuê 3 phim trở lên trong bất kỳ khoảng thời gian 24 giờ nào, và liệt kê khách hàng và các phim đó.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 205.23ms |
| **Rows Returned** | 0 | 3247 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 12.4/15
- 🏆 **Total Score:** **3.9/100**

**Expected SQL:**
```sql
WITH PhienThue AS (SELECT customer_id, film_id, rental_date, COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as phien_id FROM (SELECT r.customer_id, i.film_id, r.rental_date, r.rental_date - LAG(r.rental_date, 1, r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date) as khoang_cach_tg FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id) as khoang_cach WHERE khoang_cach_tg > '24 hours'), PhienXemLienTuc AS (SELECT phien_id, customer_id, COUNT(film_id) as so_phim_xem FROM PhienThue GROUP BY phien_id, customer_id HAVING COUNT(film_id) >= 3) SELECT c.first_name, c.last_name, pxlt.so_phim_xem, STRING_AGG(f.title, ', ') as cac_phim_da_xem FROM PhienXemLienTuc pxlt JOIN PhienThue pt ON pxlt.phien_id = pt.phien_id AND pxlt.customer_id = pt.customer_id JOIN customer c ON pxlt.customer_id = c.customer_id JOIN film f ON pt.film_id = f.film_id GROUP BY c.first_name, c.last_name, pxlt.so_phim_xem;
```

**Generated SQL:**
```sql
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    f.film_id, 
    f.title, 
    r.rental_date
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    EXISTS (
        SELECT 
            1
        FROM 
            rental r1
        WHERE 
            c.customer_id = r1.customer_id
            AND r1.rental_date BETWEEN r.rental_date AND r.rental_date + INTERVAL '1 day'
        GROUP BY 
            r1.customer_id
        HAVING 
            COUNT(r1.rental_id) >= 3
    )
ORDER BY 
    c.customer_id, 
    r.rental_date;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 45 (Level 5)**

**Câu hỏi:** For customers who rented 'AGENT TRUMAN', what other film did they rent most frequently?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 1.02ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.6/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH AgentTrumanRenters AS (SELECT DISTINCT r.customer_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE f.title = 'AGENT TRUMAN') SELECT f.title, COUNT(*) as rental_count FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE r.customer_id IN (SELECT customer_id FROM AgentTrumanRenters) AND f.title <> 'AGENT TRUMAN' GROUP BY f.title ORDER BY rental_count DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT film.title, COUNT(*) as rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.customer_id IN (
    SELECT rental.customer_id
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
    WHERE film.title = 'AGENT TRUMAN'
)
AND film.title != 'AGENT TRUMAN'
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 1;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 46 (Level 5)**

**Câu hỏi:** Đối với những khách hàng đã thuê 'AGENT TRUMAN', họ đã thuê phim nào khác thường xuyên nhất?

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 0.00ms |
| **Rows Returned** | 0 | 0 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.6/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH NguoiThueAgentTruman AS (SELECT DISTINCT r.customer_id FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE f.title = 'AGENT TRUMAN') SELECT f.title, COUNT(*) as so_luot_thue FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id WHERE r.customer_id IN (SELECT customer_id FROM NguoiThueAgentTruman) AND f.title <> 'AGENT TRUMAN' GROUP BY f.title ORDER BY so_luot_thue DESC LIMIT 1;
```

**Generated SQL:**
```sql
SELECT title, COUNT(*) as rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE customer_id IN (
    SELECT customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE title = 'AGENT TRUMAN'
)
AND title != 'AGENT TRUMAN'
GROUP BY title
ORDER BY rental_count DESC
LIMIT 1;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 47 (Level 5)**

**Câu hỏi:** Identify overstocked films: films with more than 7 copies in inventory that have not been rented in the last 6 months.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 9.16ms |
| **Rows Returned** | 0 | 72 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.2/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH LastRental AS (SELECT i.film_id, MAX(r.rental_date) as last_rental_date FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id GROUP BY i.film_id), InventoryCount AS (SELECT film_id, COUNT(*) as copy_count FROM inventory GROUP BY film_id) SELECT f.title, ic.copy_count, lr.last_rental_date FROM film f JOIN InventoryCount ic ON f.film_id = ic.film_id LEFT JOIN LastRental lr ON f.film_id = lr.film_id WHERE ic.copy_count > 7 AND (lr.last_rental_date IS NULL OR lr.last_rental_date < NOW() - INTERVAL '6 months');
```

**Generated SQL:**
```sql
SELECT film.film_id, film.title, COUNT(inventory.inventory_id) AS inventory_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id AND rental.rental_date > CURRENT_DATE - INTERVAL '6 months'
WHERE rental.rental_id IS NULL
GROUP BY film.film_id, film.title
HAVING COUNT(inventory.inventory_id) > 7;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

### ❌ **Câu 48 (Level 5)**

**Câu hỏi:** Xác định các phim tồn kho quá nhiều: phim có hơn 7 bản sao trong kho mà không được thuê trong 6 tháng qua.

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | ❌ | ✅ |
| **Execution Time** | 0.00ms | 13.91ms |
| **Rows Returned** | 0 | 872 |
| **Query Cost** | 0.00 | 0.00 |
| **Index Usage** | ❌ | ❌ |

**Scores:**
- 🎯 **Correctness:** 5.0/40
- ⚡ **Performance:** 0.0/25  
- 💰 **Cost Efficiency:** 0.0/20
- 📝 **Code Quality:** 13.2/15
- 🏆 **Total Score:** **4.0/100**

**Expected SQL:**
```sql
WITH ThueCuoi AS (SELECT i.film_id, MAX(r.rental_date) as ngay_thue_cuoi FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id GROUP BY i.film_id), DemTonKho AS (SELECT film_id, COUNT(*) as so_ban_sao FROM inventory GROUP BY film_id) SELECT f.title, dtk.so_ban_sao, tc.ngay_thue_cuoi FROM film f JOIN DemTonKho dtk ON f.film_id = dtk.film_id LEFT JOIN ThueCuoi tc ON f.film_id = tc.film_id WHERE dtk.so_ban_sao > 7 AND (tc.ngay_thue_cuoi IS NULL OR tc.ngay_thue_cuoi < NOW() - INTERVAL '6 months');
```

**Generated SQL:**
```sql
SELECT film.title, COUNT(inventory.inventory_id) AS inventory_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_date < CURRENT_DATE - INTERVAL '6 months' OR rental.rental_date IS NULL
GROUP BY film.title
HAVING COUNT(inventory.inventory_id) > 7;
```

**Errors:**
- Expected: Chỉ cho phép câu lệnh SELECT

---

## 💡 **KẾT LUẬN VÀ KHUYẾN NGHỊ**

### 🎯 **Đánh giá tổng thể: Kém (10.6/100)**

### ✅ **Điểm mạnh:**
- Code Quality cao (13.6/15) - GPT-4 tạo ra SQL syntax sạch và secure
- SQL Generation Rate: 100% - Luôn tạo ra được SQL query
- Best Practices tuân thủ tốt

### ❌ **Điểm yếu:**
- Correctness thấp (14.6/40) - Nhiều query không cho kết quả đúng
- Cost Efficiency kém (3.3/20) - Query không được tối ưu
- Performance chưa hiệu quả (8.3/25)

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
   - ✅ Basic queries (Level 1): 87.5% accuracy
   - ⚠️ Intermediate queries (Level 2+): Cần review và validation

---

**Báo cáo được tạo bởi Comprehensive SQL Benchmark System**  
**Dựa trên tiêu chuẩn benchmark đã định nghĩa**
