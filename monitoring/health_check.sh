#!/bin/bash
# Health Check Script for MegaBank API
# Monitors the health of the banking application

APP_URL="http://localhost:8080"
HEALTH_ENDPOINT="$APP_URL/health"

echo "MegaBank API Health Check"
echo "========================="
echo "Timestamp: $(date)"
echo ""

# Check if application is responding
echo "Checking API health endpoint..."
# BUG INTENTIONAL: Wrong variable name (should be $HEALTH_ENDPOINT)
response=$(curl -s -w "\n%{http_code}" $HEALTH_URL 2>/dev/null)

if [ $? -eq 0 ]; then
    http_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "200" ]; then
        echo "✓ API is healthy (HTTP $http_code)"
        echo "Response: $body"
    else
        echo "✗ API is unhealthy (HTTP $http_code)"
        echo "Response: $body"
    fi
else
    echo "✗ Cannot connect to API - service may be down"
    echo "URL: $HEALTH_ENDPOINT"
fi

echo ""
echo "Checking process status..."
if pgrep -f "app.py" > /dev/null; then
    echo "✓ Application process is running"
    pgrep -f "app.py" | xargs ps -p
else
    echo "✗ Application process is not running"
fi

echo ""
echo "Checking database connectivity..."
if nc -z localhost 5432 2>/dev/null; then
    echo "✓ Database port 5432 is accessible"
else
    echo "✗ Database port 5432 is not accessible"
fi
