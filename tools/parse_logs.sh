#!/bin/bash
# Log Parser for MegaBank Application
# Students need to complete this script to extract useful information from logs

# TODO: This script has bugs and is incomplete - fix it!

LOG_FILE="logs/app.log"

echo "MegaBank Log Parser"
echo "==================="
echo ""

# BUG: Missing 'then' keyword in if statement
if [ ! -f "$LOG_FILE" ]
    echo "ERROR: Log file $LOG_FILE not found!"
    exit 1
fi

echo "1. Counting ERROR entries..."
# TODO: Use grep to count ERROR lines
# HINT: grep -c can count matching lines
error_count=0
echo "   Found $error_count ERROR entries"
echo ""

echo "2. Finding database connection errors..."
# TODO: Use grep to find lines containing "database" AND "error" (case insensitive)
# HINT: You can pipe multiple greps together
echo "   (Complete this section)"
echo ""

echo "3. Extracting timestamps of failures..."
# TODO: Use awk or sed to extract just the timestamps from ERROR lines
# HINT: Timestamps are in format: YYYY-MM-DD HH:MM:SS,mmm
echo "   (Complete this section)"
echo ""

echo "4. Finding most recent error..."
# TODO: Use tail and grep to show the last ERROR entry
echo "   (Complete this section)"
echo ""

echo "5. Counting errors by type..."
# BUG: Wrong awk syntax - missing closing quote
echo "   Authentication errors:"
grep -i "authentication" "$LOG_FILE" | wc -l
echo "   Connection errors:
grep -i "connection" "$LOG_FILE" | wc -l
echo ""

# TODO: Create a summary report showing:
# - Total log entries
# - Error rate (errors / total entries)
# - Most common error message

echo "Log analysis complete!"
