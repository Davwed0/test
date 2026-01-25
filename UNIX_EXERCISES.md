# Unix/Linux Challenge - Exercises and Solutions

## Exercise 1: Fix File Permissions
**Challenge**: Some scripts cannot execute due to wrong permissions.

**Unix Commands Needed**:
```bash
# Find files that should be executable
find . -name "*.sh" -type f

# Check current permissions
ls -l *.sh

# Fix permissions
chmod +x start_app.sh
chmod +x database/setup_db.sh
chmod +x monitoring/health_check.sh
chmod +x test_api.sh

# Or fix all at once
find . -name "*.sh" -type f -exec chmod +x {} \;
```

## Exercise 2: Convert DOS Line Endings to Unix
**Challenge**: Scripts have Windows (CRLF) line endings and won't run on Linux.

**Unix Commands Needed**:
```bash
# Detect DOS line endings
file start_app.sh
# Output shows: "ASCII text, with CRLF line terminators"

# Convert to Unix format
dos2unix start_app.sh

# Alternative if dos2unix not available:
sed -i 's/\r$//' start_app.sh

# Or using tr:
tr -d '\r' < start_app.sh > start_app_fixed.sh
mv start_app_fixed.sh start_app.sh
```

## Exercise 3: Fix Database Password Using sed
**Challenge**: Database password is missing the exclamation mark.

**Unix Commands Needed**:
```bash
# View current password
grep DB_PASSWORD config/database.env

# Fix using sed (in-place edit)
sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' config/database.env

# Verify the change
grep DB_PASSWORD config/database.env

# Alternative using awk:
awk '{if($0 ~ /^export DB_PASSWORD=/) print "export DB_PASSWORD=BankSecure2024!"; else print $0}' config/database.env > temp && mv temp config/database.env
```

## Exercise 4: Find and Fix Python Command
**Challenge**: Scripts use `python` instead of `python3`.

**Unix Commands Needed**:
```bash
# Find all occurrences of 'python' command
grep -rn "^python " *.sh

# Replace all occurrences in start_app.sh
sed -i 's/^python /python3 /' start_app.sh

# Or replace specific line numbers (if you know them)
sed -i '23s/python/python3/' start_app.sh
sed -i '47s/python/python3/' start_app.sh

# Verify changes
grep -n "python" start_app.sh
```

## Exercise 5: Fix SQL Syntax Errors
**Challenge**: SQL file has syntax errors (missing semicolon and parenthesis).

**Unix Commands Needed**:
```bash
# Find the line with missing semicolon
grep -n "CREATE USER" database/init_db.sql

# Add semicolon after line 10
sed -i "10s/$/;/" database/init_db.sql

# Find missing closing parenthesis (line 22)
sed -i "22s/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP$/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP)/" database/init_db.sql

# Or manually with vi/vim:
vi database/init_db.sql
# Go to line 10, add semicolon
# Go to line 22, add closing parenthesis before semicolon
```

## Exercise 6: Fix File Path in Script
**Challenge**: setup_db.sh references wrong file path.

**Unix Commands Needed**:
```bash
# Find the line with the wrong path
grep -n "init_db.sql" database/setup_db.sh

# Fix the path using sed
sed -i 's|psql -f init_db.sql|psql -f database/init_db.sql|' database/setup_db.sh

# Verify
grep "psql -f" database/setup_db.sh
```

## Exercise 7: Fix Wrong Variable Name
**Challenge**: health_check.sh uses undefined variable.

**Unix Commands Needed**:
```bash
# Find the bug
grep -n "HEALTH_URL" monitoring/health_check.sh

# Fix using sed
sed -i 's/\$HEALTH_URL/\$HEALTH_ENDPOINT/g' monitoring/health_check.sh

# Verify
grep "HEALTH" monitoring/health_check.sh
```

## Exercise 8: Parse Logs with grep, awk, sed
**Challenge**: Extract useful information from log files.

**Unix Commands Needed**:
```bash
# Count ERROR lines
grep -c "ERROR" logs/app.log

# Find database errors (case insensitive)
grep -i "database" logs/app.log | grep -i "error"

# Extract just timestamps from ERROR lines
grep "ERROR" logs/app.log | awk '{print $1, $2}'

# Find last ERROR entry
grep "ERROR" logs/app.log | tail -1

# Get unique error types
grep "ERROR" logs/app.log | sed 's/^.*ERROR - //' | sort | uniq -c

# Show errors from today
TODAY=$(date +%Y-%m-%d)
grep "$TODAY" logs/app.log | grep "ERROR"
```

## Exercise 9: Fix Port Number Check
**Challenge**: Script checks wrong port (5433 instead of 5432).

**Unix Commands Needed**:
```bash
# Find the bug
grep -n "5433" start_app.sh

# Fix using sed
sed -i 's/5433/5432/g' start_app.sh

# Or use variable
sed -i 's/5433/$DB_PORT/' start_app.sh
```

## Exercise 10: Complete the Diagnostic Script
**Challenge**: Add functionality to incomplete scripts in tools/.

**Example Solutions**:
```bash
# Count ERROR entries in parse_logs.sh
error_count=$(grep -c "ERROR" "$LOG_FILE")

# Find database connection errors
grep -i "database" "$LOG_FILE" | grep -i "error"

# Extract timestamps
grep "ERROR" "$LOG_FILE" | awk '{print $1, $2}' | sed 's/,.*$//'

# Fix missing 'then'
if [ ! -f "$LOG_FILE" ]; then

# Fix missing quote
echo "   Connection errors:"
```

## Advanced Unix Exercises

### Use find to Locate Files
```bash
# Find all .sh files
find . -name "*.sh"

# Find files modified in last 24 hours
find . -type f -mtime -1

# Find files with wrong permissions
find . -name "*.sh" ! -perm -u+x

# Find and fix permissions
find . -name "*.sh" -exec chmod +x {} \;
```

### Process Management
```bash
# Find running Python processes
ps aux | grep python

# Find process by name
pgrep -f app.py

# Kill process gracefully
kill -TERM $(pgrep -f app.py)

# Force kill if needed
kill -9 $(pgrep -f app.py)

# Check if process is running
pgrep -f app.py && echo "Running" || echo "Not running"
```

### Environment Variables
```bash
# Load environment file
source config/database.env

# View specific variable
echo $DB_PASSWORD

# Export all variables from file
set -a
source config/database.env
set +a

# View all environment variables
env | grep DB_
```

### Text Processing Pipeline
```bash
# Complex log analysis
cat logs/app.log | \
  grep ERROR | \
  awk '{print $1}' | \
  sort | \
  uniq -c | \
  sort -rn

# Extract and count unique error messages
grep ERROR logs/app.log | \
  sed 's/^.*ERROR - //' | \
  sort | \
  uniq -c | \
  sort -rn | \
  head -10
```

### File Comparison and Diff
```bash
# Compare configuration files
diff config/database.env docs/DEPLOYMENT_NOTES.md

# Show only differences
diff -u file1 file2

# Compare and highlight
diff --color file1 file2
```

## Full Solution Script

Here's a complete bash script that fixes all issues:

```bash
#!/bin/bash
# Complete solution for MegaBank Unix Challenge

echo "Fixing all Unix issues..."
echo ""

echo "1. Converting DOS line endings..."
dos2unix start_app.sh 2>/dev/null || sed -i 's/\r$//' start_app.sh

echo "2. Fixing file permissions..."
chmod +x start_app.sh database/setup_db.sh monitoring/health_check.sh test_api.sh

echo "3. Fixing Python commands..."
sed -i 's/^python /python3 /' start_app.sh

echo "4. Fixing database password..."
sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' config/database.env

echo "5. Fixing SQL syntax errors..."
sed -i "10s/$/;/" database/init_db.sql
sed -i "22s/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP$/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP)/" database/init_db.sql

echo "6. Fixing database setup script path..."
sed -i 's|psql -f init_db.sql|psql -f database/init_db.sql|' database/setup_db.sh

echo "7. Fixing health check variable..."
sed -i 's/\$HEALTH_URL/\$HEALTH_ENDPOINT/g' monitoring/health_check.sh

echo "8. Fixing port number check..."
sed -i 's/5433/5432/g' start_app.sh

echo ""
echo "All issues fixed! Now run:"
echo "  ./start_app.sh"
```
