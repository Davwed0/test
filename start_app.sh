#!/bin/bash
# MegaBank Core Banking API Startup Script
# Production Environment

echo "=========================================="
echo "MegaBank Core Banking API"
echo "Starting application..."
echo "=========================================="

# Set script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Load environment variables
echo "Loading environment configuration..."
if [ -f config/database.env ]; then
    source config/database.env
else
    echo "ERROR: Configuration file not found!"
    exit 1
fi

# Check Python installation
echo "Checking Python installation..."
# BUG INTENTIONAL: Wrong Python command (should be python3)
if ! command -v python &> /dev/null; then
    echo "ERROR: Python is not installed or not in PATH"
    exit 1
fi

# Check if logs directory exists
if [ ! -d "logs" ]; then
    echo "Creating logs directory..."
    mkdir logs
fi

# Check database connectivity
echo "Testing database connection..."
# BUG INTENTIONAL: Using wrong port (should use $DB_PORT)
if ! nc -z $DB_HOST 5433 2>/dev/null; then
    echo "WARNING: Cannot connect to database at $DB_HOST:5433"
    echo "Attempting to start anyway..."
fi

# Check if port is available
echo "Checking if port $APP_PORT is available..."
if lsof -Pi :$APP_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "ERROR: Port $APP_PORT is already in use!"
    echo "Please stop the existing process or choose a different port."
    exit 1
fi

# Start the application
echo "Starting Banking API..."
echo "Application should be available at http://localhost:$APP_PORT"
echo "Press Ctrl+C to stop"
echo ""

# BUG INTENTIONAL: Wrong Python command (should be python3)
python app.py
