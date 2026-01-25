-- MegaBank Database Initialization Script
-- Core Banking Database Schema

-- Create database (run this as postgres user first)
-- CREATE DATABASE banking_db;

-- Create user and grant privileges
-- BUG INTENTIONAL: Missing semicolon
CREATE USER bank_user WITH PASSWORD 'BankSecure2024!'

GRANT ALL PRIVILEGES ON DATABASE banking_db TO bank_user;

-- Connect to banking_db before running below commands
\c banking_db

-- Accounts table
CREATE TABLE IF NOT EXISTS accounts (
    account_number VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    account_type VARCHAR(20) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- BUG INTENTIONAL: Missing closing parenthesis
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
;

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account VARCHAR(20) REFERENCES accounts(account_number),
    to_account VARCHAR(20) REFERENCES accounts(account_number),
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'completed'
);

-- Insert sample data
INSERT INTO accounts (account_number, customer_name, balance, account_type) VALUES
    ('ACC001', 'John Smith', 15000.00, 'savings'),
    ('ACC002', 'Jane Doe', 25000.00, 'checking'),
    ('ACC003', 'Bob Johnson', 50000.00, 'savings'),
    ('ACC004', 'Alice Williams', 10000.00, 'checking');

-- Create indexes for performance
CREATE INDEX idx_transactions_from ON transactions(from_account);
CREATE INDEX idx_transactions_to ON transactions(to_account);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- Grant table permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bank_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bank_user;

-- Display success message
SELECT 'Database initialized successfully!' AS status;
