#!/bin/bash
# MegaBank System Diagnostics Script
# Use this to help diagnose Unix-level issues

echo "=================================="
echo "MegaBank System Diagnostics"
echo "=================================="
echo ""

echo "1. Checking File Permissions"
echo "----------------------------"
ls -la *.sh 2>/dev/null
ls -la database/*.sh 2>/dev/null
ls -la monitoring/*.sh 2>/dev/null
echo ""

echo "2. Checking for DOS Line Endings"
echo "--------------------------------"
file *.sh 2>/dev/null | grep -i "CRLF"
file database/*.sh 2>/dev/null | grep -i "CRLF"
echo ""

echo "3. Checking Configuration Files"
echo "-------------------------------"
if [ -f config/database.env ]; then
    echo "✓ config/database.env exists"
    echo "  Checking for syntax errors..."
    bash -n config/database.env 2>&1 | head -5
else
    echo "✗ config/database.env not found"
fi
echo ""

echo "4. Checking Python Installation"
echo "-------------------------------"
which python 2>/dev/null && echo "  python -> $(which python)" || echo "  python: not found"
which python3 2>/dev/null && echo "  python3 -> $(which python3)" || echo "  python3: not found"
echo ""

echo "5. Checking Database Connectivity"
echo "---------------------------------"
nc -z localhost 5432 2>/dev/null && echo "✓ Port 5432 is open" || echo "✗ Port 5432 is closed/unreachable"
echo ""

echo "6. Checking for Running Processes"
echo "---------------------------------"
pgrep -f "app.py" > /dev/null && echo "✓ app.py is running (PID: $(pgrep -f app.py))" || echo "✗ app.py is not running"
echo ""

echo "7. Recent Log Entries"
echo "--------------------"
if [ -f logs/app.log ]; then
    echo "Last 5 lines from logs/app.log:"
    tail -5 logs/app.log
else
    echo "✗ logs/app.log not found"
fi
echo ""

echo "=================================="
echo "Diagnostics Complete"
echo "=================================="
echo ""
echo "Hints:"
echo "- Use 'dos2unix' to fix line ending issues"
echo "- Use 'chmod +x' to make scripts executable"
echo "- Use 'grep -r' to search for text in files"
echo "- Use 'sed' to edit configuration files"
echo "- Check environment variables with 'env' or 'printenv'"
