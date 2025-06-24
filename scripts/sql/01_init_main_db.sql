-- Initialize main database for Text-to-SQL system
-- This script runs automatically when PostgreSQL starts

-- Create extensions
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create schema for system tables
CREATE SCHEMA IF NOT EXISTS text2sql_system;

-- Table để lưu conversation history
CREATE TABLE IF NOT EXISTS text2sql_system.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_query TEXT NOT NULL,
    generated_sql TEXT,
    result_data JSONB,
    execution_success BOOLEAN,
    error_message TEXT,
    model_used VARCHAR(50),
    agent_type VARCHAR(20) CHECK (agent_type IN ('single', 'multi')),
    execution_time_ms INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table để lưu agent performance metrics
CREATE TABLE IF NOT EXISTS text2sql_system.agent_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    experiment_type VARCHAR(20) CHECK (experiment_type IN ('single_agent', 'multi_agent')),
    dataset_name VARCHAR(50),
    query_complexity VARCHAR(20),
    accuracy_score DECIMAL(5,4),
    execution_time_ms INTEGER,
    token_usage INTEGER,
    cost_usd DECIMAL(10,6),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table để lưu database schemas cho agents
CREATE TABLE IF NOT EXISTS text2sql_system.database_schemas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    database_name VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    column_name VARCHAR(100) NOT NULL,
    column_type VARCHAR(50) NOT NULL,
    is_primary_key BOOLEAN DEFAULT FALSE,
    is_foreign_key BOOLEAN DEFAULT FALSE,
    foreign_table VARCHAR(100),
    foreign_column VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table để lưu test questions và expected results
CREATE TABLE IF NOT EXISTS text2sql_system.test_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question TEXT NOT NULL,
    expected_sql TEXT NOT NULL,
    database_name VARCHAR(100) NOT NULL,
    difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),
    question_type VARCHAR(50),
    language VARCHAR(10) CHECK (language IN ('en', 'vi')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_conversations_timestamp ON text2sql_system.conversations(timestamp);
CREATE INDEX IF NOT EXISTS idx_conversations_model ON text2sql_system.conversations(model_used);
CREATE INDEX IF NOT EXISTS idx_agent_metrics_experiment ON text2sql_system.agent_metrics(experiment_type);
CREATE INDEX IF NOT EXISTS idx_schemas_database ON text2sql_system.database_schemas(database_name);
CREATE INDEX IF NOT EXISTS idx_test_questions_difficulty ON text2sql_system.test_questions(difficulty_level);

-- Insert sample data for testing
INSERT INTO text2sql_system.test_questions (question, expected_sql, database_name, difficulty_level, question_type, language) VALUES
('Hiển thị tất cả nhân viên', 'SELECT * FROM nhan_vien;', 'vietnamese_test', 1, 'select_all', 'vi'),
('Tìm nhân viên có lương cao nhất', 'SELECT ho_ten, luong FROM nhan_vien WHERE luong = (SELECT MAX(luong) FROM nhan_vien);', 'vietnamese_test', 3, 'aggregation', 'vi'),
('Đếm số nhân viên theo phòng ban', 'SELECT phong_ban, COUNT(*) FROM nhan_vien GROUP BY phong_ban;', 'vietnamese_test', 2, 'group_by', 'vi'),
('Show all customers', 'SELECT * FROM customer;', 'dvdrental', 1, 'select_all', 'en'),
('Find top 10 most rented films', 'SELECT f.title, COUNT(r.rental_id) as rental_count FROM film f JOIN inventory i ON f.film_id = i.film_id JOIN rental r ON i.inventory_id = r.inventory_id GROUP BY f.title ORDER BY rental_count DESC LIMIT 10;', 'dvdrental', 4, 'complex_join', 'en');

-- Create user for applications
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'text2sql_app') THEN
        CREATE USER text2sql_app WITH PASSWORD 'app_password123';
    END IF;
END
$$;

-- Grant permissions
GRANT USAGE ON SCHEMA text2sql_system TO text2sql_app;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA text2sql_system TO text2sql_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA text2sql_system TO text2sql_app;

-- Create views for easy access
CREATE OR REPLACE VIEW text2sql_system.v_recent_conversations AS
SELECT 
    id,
    user_query,
    generated_sql,
    execution_success,
    model_used,
    agent_type,
    execution_time_ms,
    timestamp
FROM text2sql_system.conversations
ORDER BY timestamp DESC
LIMIT 100;

CREATE OR REPLACE VIEW text2sql_system.v_agent_performance AS
SELECT 
    experiment_type,
    dataset_name,
    AVG(accuracy_score) as avg_accuracy,
    AVG(execution_time_ms) as avg_execution_time,
    COUNT(*) as test_count,
    MAX(timestamp) as last_test
FROM text2sql_system.agent_metrics
GROUP BY experiment_type, dataset_name;

COMMENT ON DATABASE text2sql_db IS 'Main database cho Multi-Agent Text-to-SQL Luận Văn system';
COMMENT ON SCHEMA text2sql_system IS 'Schema chứa system tables cho tracking và metrics';
COMMENT ON TABLE text2sql_system.conversations IS 'Lưu trữ conversation history giữa user và agents';
COMMENT ON TABLE text2sql_system.agent_metrics IS 'Metrics và performance data của các agents';
COMMENT ON TABLE text2sql_system.database_schemas IS 'Metadata về database schemas cho agents';
COMMENT ON TABLE text2sql_system.test_questions IS 'Test questions và expected results cho evaluation'; 