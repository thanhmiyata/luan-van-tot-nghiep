#!/usr/bin/env python3
"""
Database Setup Script cho Luận Văn Multi-Agent Text-to-SQL
Download và setup các test databases: Spider, DVD Rental, và test datasets
"""

import os
import json
import psycopg2
import requests
import zipfile
import tarfile
from pathlib import Path
import sys

# Database connection


def get_db_connection():
    """Kết nối đến PostgreSQL database"""
    try:
        conn = psycopg2.connect(
            host="postgres",
            database="text2sql_db",
            user="postgres",
            password="postgres123"
        )
        return conn
    except Exception as e:
        print(f"❌ Lỗi kết nối database: {e}")
        return None


def download_file(url, filename):
    """Download file từ URL"""
    print(f"📥 Downloading {filename}...")
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()

        with open(filename, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"✅ Downloaded {filename}")
        return True
    except Exception as e:
        print(f"❌ Lỗi download {filename}: {e}")
        return False


def setup_dvd_rental_database():
    """Setup DVD Rental sample database"""
    print("🎬 Setting up DVD Rental database...")

    dvd_url = "https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip"
    dvd_zip = "/tmp/dvdrental.zip"

    # Download DVD Rental database
    if download_file(dvd_url, dvd_zip):
        # Extract
        with zipfile.ZipFile(dvd_zip, 'r') as zip_ref:
            zip_ref.extractall("/tmp/")

        # Restore database
        conn = get_db_connection()
        if conn:
            cur = conn.cursor()

            # Create DVD rental database
            cur.execute("CREATE DATABASE dvdrental;")
            conn.commit()
            conn.close()

            # Restore from tar file
            os.system(
                "pg_restore -h postgres -U postgres -d dvdrental /tmp/dvdrental.tar")
            print("✅ DVD Rental database setup completed")
        else:
            print("❌ Không thể setup DVD Rental database")


def setup_spider_dataset():
    """Download và setup Spider dataset"""
    print("🕷️ Setting up Spider dataset...")

    spider_url = "https://yale-lily.github.io/spider/evaluation.zip"
    spider_zip = "/tmp/spider.zip"

    if download_file(spider_url, spider_zip):
        # Extract Spider dataset
        with zipfile.ZipFile(spider_zip, 'r') as zip_ref:
            zip_ref.extractall("/app/datasets/spider/")

        print("✅ Spider dataset downloaded")

        # Load Spider databases vào PostgreSQL
        setup_spider_databases()


def setup_spider_databases():
    """Setup các databases từ Spider dataset"""
    print("🗄️ Setting up Spider databases...")

    spider_path = Path("/app/datasets/spider/")
    database_path = spider_path / "database"

    if not database_path.exists():
        print("❌ Spider database path không tồn tại")
        return

    conn = get_db_connection()
    if not conn:
        return

    cur = conn.cursor()

    # Đọc danh sách databases từ Spider
    for db_dir in database_path.iterdir():
        if db_dir.is_dir():
            db_name = db_dir.name
            sqlite_file = db_dir / f"{db_name}.sqlite"

            if sqlite_file.exists():
                print(f"📊 Setting up database: {db_name}")

                # Create PostgreSQL database
                try:
                    cur.execute(f"CREATE DATABASE {db_name};")
                    conn.commit()

                    # Convert SQLite to PostgreSQL (simplified)
                    # Trong thực tế cần tool chuyển đổi SQLite -> PostgreSQL
                    print(f"✅ Created database: {db_name}")

                except Exception as e:
                    print(f"⚠️ Database {db_name} đã tồn tại hoặc lỗi: {e}")
                    conn.rollback()

    conn.close()


def setup_custom_test_databases():
    """Setup custom test databases cho Vietnamese queries"""
    print("🇻🇳 Setting up Vietnamese test databases...")

    conn = get_db_connection()
    if not conn:
        return

    cur = conn.cursor()

    # Tạo database cho Vietnamese test cases
    vietnamese_sql = """
    -- Database cho Vietnamese Text-to-SQL testing
    CREATE DATABASE vietnamese_test;
    """

    try:
        cur.execute("CREATE DATABASE vietnamese_test;")
        conn.commit()

        # Switch to vietnamese_test database
        conn.close()
        conn = psycopg2.connect(
            host="postgres",
            database="vietnamese_test",
            user="postgres",
            password="postgres123"
        )
        cur = conn.cursor()

        # Tạo tables mẫu cho testing Vietnamese
        vietnamese_tables = """
        -- Bảng nhân viên
        CREATE TABLE nhan_vien (
            id SERIAL PRIMARY KEY,
            ho_ten VARCHAR(100) NOT NULL,
            tuoi INTEGER,
            phong_ban VARCHAR(50),
            luong DECIMAL(10,2),
            ngay_vao_lam DATE
        );
        
        -- Bảng sản phẩm  
        CREATE TABLE san_pham (
            id SERIAL PRIMARY KEY,
            ten_san_pham VARCHAR(100) NOT NULL,
            gia DECIMAL(10,2),
            loai_san_pham VARCHAR(50),
            ton_kho INTEGER
        );
        
        -- Bảng đơn hàng
        CREATE TABLE don_hang (
            id SERIAL PRIMARY KEY,
            khach_hang VARCHAR(100),
            ngay_dat DATE,
            tong_tien DECIMAL(10,2),
            trang_thai VARCHAR(20)
        );
        
        -- Insert sample data
        INSERT INTO nhan_vien (ho_ten, tuoi, phong_ban, luong, ngay_vao_lam) VALUES
        ('Nguyễn Văn An', 25, 'IT', 15000000, '2023-01-15'),
        ('Trần Thị Bình', 30, 'Marketing', 12000000, '2022-06-01'),
        ('Lê Văn Cường', 28, 'IT', 18000000, '2023-03-10'),
        ('Phạm Thị Dung', 35, 'HR', 20000000, '2021-01-01');
        
        INSERT INTO san_pham (ten_san_pham, gia, loai_san_pham, ton_kho) VALUES
        ('Laptop Dell', 20000000, 'Electronics', 50),
        ('iPhone 15', 25000000, 'Electronics', 30),
        ('Bàn làm việc', 2000000, 'Furniture', 100),
        ('Ghế xoay', 1500000, 'Furniture', 80);
        
        INSERT INTO don_hang (khach_hang, ngay_dat, tong_tien, trang_thai) VALUES
        ('Nguyễn Văn A', '2024-01-15', 45000000, 'Hoàn thành'),
        ('Trần Thị B', '2024-01-20', 3500000, 'Đang xử lý'),
        ('Lê Văn C', '2024-01-25', 25000000, 'Hoàn thành');
        """

        cur.execute(vietnamese_tables)
        conn.commit()

        print("✅ Vietnamese test database setup completed")

    except Exception as e:
        print(f"❌ Lỗi setup Vietnamese database: {e}")
        conn.rollback()
    finally:
        conn.close()


def load_existing_datasets():
    """Load các datasets có sẵn trong Data Set folder"""
    print("📚 Loading existing test datasets...")

    datasets_path = Path("/app/datasets")

    # Process các file JSON test questions
    json_files = [
        "50_test_dataset.json",
        "lv1_test_question.json",
        "lv2_test_question.json",
        "lv3_test_question.json",
        "lv4_test_question.json",
        "lv5_test_question.json"
    ]

    for json_file in json_files:
        file_path = datasets_path / json_file
        if file_path.exists():
            print(f"📊 Processing {json_file}...")
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                print(f"✅ Loaded {len(data)} entries from {json_file}")
            except Exception as e:
                print(f"❌ Lỗi đọc {json_file}: {e}")


def create_schema_documentation():
    """Tạo documentation cho các database schemas"""
    print("📖 Creating schema documentation...")

    docs_content = """
# Database Schemas Documentation

## 1. DVD Rental Database
- **Mô tả**: Database mẫu cho hệ thống cho thuê DVD
- **Tables**: customer, film, actor, rental, payment, etc.
- **Use case**: Testing complex joins, aggregations

## 2. Spider Databases  
- **Mô tả**: Benchmark dataset cho Text-to-SQL
- **Databases**: 200+ different databases
- **Use case**: Standard evaluation, complexity testing

## 3. Vietnamese Test Database
- **Mô tả**: Database tiếng Việt cho testing
- **Tables**: nhan_vien, san_pham, don_hang
- **Use case**: Vietnamese language support testing

## Usage Examples

### DVD Rental Queries
```sql
-- Tìm top 10 phim được thuê nhiều nhất
SELECT f.title, COUNT(r.rental_id) as rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id  
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;
```

### Vietnamese Queries
```sql
-- Tìm nhân viên có lương cao nhất
SELECT ho_ten, luong FROM nhan_vien WHERE luong = (SELECT MAX(luong) FROM nhan_vien);
```
"""

    with open("/app/datasets/schema_documentation.md", "w", encoding="utf-8") as f:
        f.write(docs_content)

    print("✅ Schema documentation created")


def main():
    """Main setup function"""
    print("🚀 Starting database setup for Luận Văn Multi-Agent Text-to-SQL...")
    print("=" * 70)

    # Wait for PostgreSQL to be ready
    print("⏳ Waiting for PostgreSQL to be ready...")
    import time
    time.sleep(10)

    # Setup databases
    setup_dvd_rental_database()
    setup_spider_dataset()
    setup_custom_test_databases()
    load_existing_datasets()
    create_schema_documentation()

    print("=" * 70)
    print("✅ Database setup completed!")
    print("📊 Available databases:")
    print("  - text2sql_db (main)")
    print("  - dvdrental (sample)")
    print("  - vietnamese_test (custom)")
    print("  - spider databases (benchmark)")
    print("=" * 70)


if __name__ == "__main__":
    main()
