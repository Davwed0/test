#!/bin/bash
# API Testing Script
# Quick tests to verify the API is working correctly

API_URL="http://localhost:8080"

echo "MegaBank API Testing Suite"
echo "==========================="
echo ""

# Test 1: Health Check
echo "Test 1: Health Check"
echo "-------------------"
curl -s "$API_URL/health" | python3 -m json.tool
echo ""
echo ""

# Test 2: API Status
echo "Test 2: API Status"
echo "------------------"
curl -s "$API_URL/api/status" | python3 -m json.tool
echo ""
echo ""

# Test 3: Get Account Balance
echo "Test 3: Get Account Balance (ACC001)"
echo "------------------------------------"
curl -s "$API_URL/api/accounts/ACC001/balance" | python3 -m json.tool
echo ""
echo ""

# Test 4: Get Another Account Balance
echo "Test 4: Get Account Balance (ACC002)"
echo "------------------------------------"
curl -s "$API_URL/api/accounts/ACC002/balance" | python3 -m json.tool
echo ""
echo ""

echo "Testing complete!"
echo "If all tests show valid JSON responses, the API is working correctly."
