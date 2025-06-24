-- Sample queries cho testing Multi-Agent Text-to-SQL system
-- File này chứa các queries mẫu để test trên các databases

-- ==========================================
-- VIETNAMESE TEST DATABASE QUERIES
-- ==========================================

-- Level 1: Basic SELECT queries
-- Question: "Hiển thị tất cả nhân viên"
SELECT * FROM nhan_vien;

-- Question: "Cho tôi xem danh sách sản phẩm"
SELECT * FROM san_pham;

-- Question: "Hiển thị tất cả đơn hàng"
SELECT * FROM don_hang;

-- Level 2: WHERE conditions
-- Question: "Tìm nhân viên trong phòng IT"
SELECT ho_ten, tuoi, luong FROM nhan_vien WHERE phong_ban = 'IT';

-- Question: "Sản phẩm nào có giá trên 10 triệu?"
SELECT ten_san_pham, gia FROM san_pham WHERE gia > 10000000;

-- Question: "Đơn hàng nào đã hoàn thành?"
SELECT * FROM don_hang WHERE trang_thai = 'Hoàn thành';

-- Level 3: Aggregations
-- Question: "Đếm số nhân viên theo phòng ban"
SELECT phong_ban, COUNT(*) as so_nhan_vien FROM nhan_vien GROUP BY phong_ban;

-- Question: "Tính tổng tiền của tất cả đơn hàng"
SELECT SUM(tong_tien) as tong_doanh_thu FROM don_hang;

-- Question: "Lương trung bình của nhân viên"
SELECT AVG(luong) as luong_trung_binh FROM nhan_vien;

-- Level 4: Complex queries
-- Question: "Nhân viên có lương cao nhất trong mỗi phòng ban"
SELECT phong_ban, ho_ten, luong 
FROM nhan_vien n1
WHERE luong = (
    SELECT MAX(luong) 
    FROM nhan_vien n2 
    WHERE n2.phong_ban = n1.phong_ban
);

-- Question: "Sản phẩm bán chạy nhất (giả sử có bảng chi tiết đơn hàng)"
-- Note: Cần thêm bảng chi_tiet_don_hang để query này hoạt động

-- ==========================================
-- DVD RENTAL DATABASE QUERIES  
-- ==========================================

-- Level 1: Basic queries
-- Question: "Show all customers"
SELECT * FROM customer LIMIT 10;

-- Question: "List all films"
SELECT title, release_year, rating FROM film LIMIT 10;

-- Question: "Show all actors"
SELECT first_name, last_name FROM actor LIMIT 10;

-- Level 2: Simple joins
-- Question: "Show customer names with their addresses"
SELECT c.first_name, c.last_name, a.address, a.district
FROM customer c
JOIN address a ON c.address_id = a.address_id
LIMIT 10;

-- Question: "List films with their categories"
SELECT f.title, c.name as category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
LIMIT 10;

-- Level 3: Aggregations
-- Question: "Count films by rating"
SELECT rating, COUNT(*) as film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;

-- Question: "Average rental duration by category"
SELECT c.name as category, AVG(f.rental_duration) as avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration DESC;

-- Level 4: Complex queries
-- Question: "Top 10 most rented films"
SELECT f.title, COUNT(r.rental_id) as rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- Question: "Monthly revenue"
SELECT 
    DATE_TRUNC('month', payment_date) as month,
    SUM(amount) as total_revenue
FROM payment
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY month;

-- Question: "Customers who rented more than 30 films"
SELECT 
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) as rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 30
ORDER BY rental_count DESC;

-- Level 5: Very complex queries
-- Question: "Films that have never been rented"
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- Question: "Customer lifetime value with ranking"
WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) as total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT 
    first_name,
    last_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) as customer_rank
FROM customer_revenue
ORDER BY total_spent DESC
LIMIT 20;

-- ==========================================
-- SPIDER DATASET SAMPLE QUERIES
-- ==========================================

-- Note: Các queries này sẽ được load từ Spider dataset
-- Đây là format mẫu cho Spider questions

-- Question: "How many heads of the departments are older than 56?"
-- Database: department_management
-- SQL: SELECT count(*) FROM head WHERE age > 56

-- Question: "List the name, born state and age of the heads of departments ordered by age."
-- Database: department_management  
-- SQL: SELECT name, born_state, age FROM head ORDER BY age

-- Question: "List the creation year, name and budget of each department."
-- Database: department_management
-- SQL: SELECT creation, name, budget_in_billions FROM department

-- ==========================================
-- TESTING QUERIES FOR SYSTEM VALIDATION
-- ==========================================

-- Test query để kiểm tra kết nối
SELECT 'Database connection successful' as status;

-- Test query để kiểm tra system tables
SELECT COUNT(*) as conversation_count FROM text2sql_system.conversations;

-- Test query để kiểm tra metrics
SELECT 
    experiment_type,
    COUNT(*) as test_count,
    AVG(accuracy_score) as avg_accuracy
FROM text2sql_system.agent_metrics
GROUP BY experiment_type;

-- Test schema information query
SELECT 
    database_name,
    COUNT(DISTINCT table_name) as table_count,
    COUNT(*) as column_count
FROM text2sql_system.database_schemas
GROUP BY database_name; 