# 🤖 AI PROMPT: Generate Text-to-SQL Dataset for DVD Rental Database

## 📋 TASK OVERVIEW
Generate exactly **1000 natural language questions** with corresponding SQL queries for a DVD Rental database. Questions should be in both Vietnamese and English, categorized by difficulty levels 1-5.

## 🗄️ DATABASE SCHEMA (PostgreSQL)

### Tables and Relationships:

**1. film** (Movie catalog)
- film_id (PRIMARY KEY)
- title, description, release_year, language_id
- rental_duration, rental_rate, replacement_cost
- length (minutes), rating (G, PG, PG-13, R, NC-17)
- special_features, last_update

**2. actor** (Actor information)
- actor_id (PRIMARY KEY)
- first_name, last_name, last_update

**3. category** (Film categories)
- category_id (PRIMARY KEY)
- name (Action, Comedy, Drama, Horror, etc.)

**4. customer** (Customer details)
- customer_id (PRIMARY KEY)
- first_name, last_name, email, address_id
- store_id, active, create_date, last_update

**5. rental** (Rental transactions)
- rental_id (PRIMARY KEY)
- rental_date, inventory_id, customer_id
- return_date, staff_id, last_update

**6. payment** (Payment records)
- payment_id (PRIMARY KEY)
- customer_id, staff_id, rental_id
- amount, payment_date

**7. inventory** (Available film copies)
- inventory_id (PRIMARY KEY)
- film_id, store_id, last_update

**8. staff** (Store employees)
- staff_id (PRIMARY KEY)
- first_name, last_name, address_id, store_id
- email, username, password, active

**9. store** (Store locations)
- store_id (PRIMARY KEY)
- manager_staff_id, address_id, last_update

**Key Junction Tables:**
- film_actor (film_id, actor_id)
- film_category (film_id, category_id)

## 📊 DIFFICULTY LEVELS & DISTRIBUTION

### Level 1 (300 questions) - Basic
- Single table queries
- Simple SELECT, COUNT, basic WHERE
- Examples: "How many films?", "List all categories"

### Level 2 (250 questions) - Intermediate Low
- 2-table JOINs
- GROUP BY, ORDER BY, basic aggregation
- Examples: "Films by category", "Top customers"

### Level 3 (200 questions) - Intermediate
- 3-4 table JOINs
- Subqueries, HAVING, date functions
- Examples: "Revenue by month", "Overdue rentals"

### Level 4 (150 questions) - Advanced
- Complex subqueries, window functions
- EXISTS/NOT EXISTS, advanced aggregation
- Examples: "Films above category average", "Customer ranking"

### Level 5 (100 questions) - Expert
- Complex business logic, CTEs
- Advanced analytics, recursive queries
- Examples: "Cohort analysis", "Customer lifetime value"

## 🌍 LANGUAGE DISTRIBUTION
- **500 questions in Vietnamese** (natural, conversational)
- **500 questions in English** (business terminology)

## 📝 OUTPUT FORMAT

For each question, provide this JSON structure:

```json
{
  "question_id": "Q001",
  "level": 1,
  "language": "vi",
  "domain": "basic_business",
  "question": "Có bao nhiêu bộ phim trong cơ sở dữ liệu?",
  "sql_query": "SELECT COUNT(*) FROM film;",
  "explanation": "Đếm tổng số bản ghi trong bảng film",
  "expected_result_type": "single_value",
  "complexity_features": ["single_table", "count_aggregate", "no_join"],
  "business_context": "inventory_overview"
}
```

## 🎯 DOMAIN CATEGORIES
- **basic_business** (40%): Films, customers, rentals
- **financial_analysis** (25%): Revenue, payments, profitability
- **inventory_management** (20%): Stock, availability, turnover
- **customer_analytics** (15%): Behavior, segmentation, retention

## ✅ VALIDATION REQUIREMENTS

1. **SQL Syntax**: Must be valid PostgreSQL
2. **Schema Compliance**: Use exact table/column names
3. **Business Logic**: Results must make business sense
4. **Language Quality**: Natural, conversational questions
5. **Complexity Consistency**: SQL complexity matches level

## 📋 SAMPLE QUESTIONS BY LEVEL

### Level 1 Examples:
- VI: "Có bao nhiêu thể loại phim?"
- EN: "How many film categories are there?"
- SQL: `SELECT COUNT(*) FROM category;`

### Level 2 Examples:
- VI: "Hiển thị 5 khách hàng thuê phim nhiều nhất"
- EN: "Show top 5 customers by rental count"
- SQL: `SELECT c.first_name, c.last_name, COUNT(r.rental_id) FROM customer c JOIN rental r ON c.customer_id = r.customer_id GROUP BY c.customer_id ORDER BY COUNT(r.rental_id) DESC LIMIT 5;`

### Level 3 Examples:
- VI: "Doanh thu theo từng tháng năm 2005"
- EN: "Monthly revenue for year 2005"
- SQL: `SELECT DATE_TRUNC('month', p.payment_date) as month, SUM(p.amount) FROM payment p WHERE EXTRACT(year FROM p.payment_date) = 2005 GROUP BY month ORDER BY month;`

## 🚀 GENERATION INSTRUCTIONS

1. **Start with Level 1** and progress to Level 5
2. **Alternate languages** (Vietnamese/English) within each level
3. **Vary domains** across questions
4. **Ensure SQL validity** - use proper JOIN syntax, table aliases
5. **Make questions natural** - avoid forced or artificial phrasing
6. **Include business context** - questions should reflect real business needs

## 📤 FINAL OUTPUT

Provide the complete dataset as a JSON array with exactly 1000 questions, properly formatted and validated. Each question should follow the specified JSON structure.

---

**Ready to generate? Please create the complete 1000-question dataset now!** 🎯 