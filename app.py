#!/usr/bin/env python3
"""
MegaBank Core Banking API
Production Version 2.3.1
"""

import os
import sys
import json
import logging
from datetime import datetime
from flask import Flask, jsonify, request
import psycopg2
from psycopg2 import pool

# Initialize Flask app
app = Flask(__name__)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/app.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'banking_db'),
    'user': os.getenv('DB_USER', 'bank_user'),
    'password': os.getenv('DB_PASSWORD', 'secure_password')
}

# Initialize database connection pool
db_pool = None

def init_db_pool():
    """Initialize database connection pool"""
    global db_pool
    try:
        db_pool = psycopg2.pool.SimpleConnectionPool(
            1, 10,
            host=DB_CONFIG['host'],
            port=DB_CONFIG['port'],
            database=DB_CONFIG['database'],
            user=DB_CONFIG['user'],
            password=DB_CONFIG['password']
        )
        logger.info("Database connection pool initialized successfully")
        return True
    except Exception as e:
        logger.error(f"Failed to initialize database pool: {e}")
        return False

def get_db_connection():
    """Get a database connection from the pool"""
    if db_pool:
        return db_pool.getconn()
    return None

def return_db_connection(conn):
    """Return a database connection to the pool"""
    if db_pool and conn:
        db_pool.putconn(conn)

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    status = {
        'service': 'MegaBank Core Banking API',
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'version': '2.3.1'
    }
    
    # Check database connectivity
    try:
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute('SELECT 1')
            cursor.close()
            return_db_connection(conn)
            status['database'] = 'connected'
        else:
            status['database'] = 'disconnected'
            status['status'] = 'degraded'
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        status['database'] = 'error'
        status['status'] = 'unhealthy'
    
    return jsonify(status), 200 if status['status'] == 'healthy' else 503

@app.route('/api/accounts/<account_id>/balance', methods=['GET'])
def get_balance(account_id):
    """Get account balance"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            'SELECT account_number, customer_name, balance FROM accounts WHERE account_number = %s',
            (account_id,)
        )
        result = cursor.fetchone()
        cursor.close()
        return_db_connection(conn)
        
        if result:
            return jsonify({
                'account_number': result[0],
                'customer_name': result[1],
                'balance': float(result[2])
            }), 200
        else:
            return jsonify({'error': 'Account not found'}), 404
    except Exception as e:
        logger.error(f"Error fetching balance: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/transactions', methods=['POST'])
def create_transaction():
    """Create a new transaction"""
    try:
        data = request.get_json()
        
        if not data or 'from_account' not in data or 'to_account' not in data or 'amount' not in data:
            return jsonify({'error': 'Missing required fields'}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Log transaction
        cursor.execute(
            '''INSERT INTO transactions (from_account, to_account, amount, transaction_date)
               VALUES (%s, %s, %s, %s) RETURNING transaction_id''',
            (data['from_account'], data['to_account'], data['amount'], datetime.now())
        )
        
        transaction_id = cursor.fetchone()[0]
        conn.commit()
        cursor.close()
        return_db_connection(conn)
        
        logger.info(f"Transaction {transaction_id} created successfully")
        return jsonify({
            'transaction_id': transaction_id,
            'status': 'completed'
        }), 201
    except Exception as e:
        logger.error(f"Error creating transaction: {e}")
        return jsonify({'error': 'Transaction failed'}), 500

@app.route('/api/status', methods=['GET'])
def api_status():
    """API status endpoint"""
    return jsonify({
        'api': 'MegaBank Core Banking API',
        'version': '2.3.1',
        'environment': os.getenv('ENVIRONMENT', 'production'),
        'uptime': 'operational'
    }), 200

def main():
    """Main application entry point"""
    logger.info("Starting MegaBank Core Banking API...")
    
    # Initialize database
    if not init_db_pool():
        logger.error("Failed to connect to database. Exiting...")
        sys.exit(1)
    
    # Start Flask app
    port = int(os.getenv('APP_PORT', '8080'))
    logger.info(f"Starting API server on port {port}")
    
    app.run(
        host='0.0.0.0',
        port=port,
        debug=False
    )

if __name__ == '__main__':
    main()
