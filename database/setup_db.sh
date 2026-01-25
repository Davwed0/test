#!/bin/bash
# Database Setup Script for MegaBank
# This script initializes PostgreSQL database

echo "MegaBank Database Setup"
echo "======================="

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "ERROR: PostgreSQL is not installed!"
    echo "Please install PostgreSQL first:"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql postgresql-contrib"
    echo "  CentOS/RHEL: sudo yum install postgresql-server postgresql-contrib"
    exit 1
fi

# Check if PostgreSQL service is running
if ! systemctl is-active --quiet postgresql; then
    echo "PostgreSQL service is not running. Starting it..."
    sudo systemctl start postgresql
    sleep 2
fi

echo "Initializing database..."

# Run SQL script as postgres user
# BUG INTENTIONAL: Wrong file path (should be database/init_db.sql)
sudo -u postgres psql -f init_db.sql

if [ $? -eq 0 ]; then
    echo "Database setup completed successfully!"
else
    echo "ERROR: Database setup failed!"
    exit 1
fi
