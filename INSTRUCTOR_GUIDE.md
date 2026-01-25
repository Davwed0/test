# Instructor Guide - Unix/Linux Administration Challenge

## Overview

This simulation contains a realistic banking application with **intentionally placed Unix/Linux issues** that students need to troubleshoot and fix using command-line tools. It focuses on practical Unix skills: bash scripting, text processing (grep/sed/awk), file permissions, process management, and system administration.

## Learning Objectives

Students will practice:
- **Bash scripting**: Debug and fix shell script syntax errors
- **Text processing**: Use grep, sed, awk to search and modify files
- **File permissions**: Use chmod/chown to fix access issues
- **Line endings**: Convert DOS (CRLF) to Unix (LF) format
- **Environment variables**: Source and manage configuration
- **Process management**: Use ps, pgrep, kill, lsof
- **System tools**: find, tar, diff, file, nc
- **Log analysis**: Parse and extract information from logs
- **Problem solving**: Systematic debugging approach

## Intentional Issues (DO NOT SHARE WITH STUDENTS)

### Issue #1: File Permissions (Unix Fundamentals)
- **Location:** `start_app.sh`, `database/setup_db.sh`
- **Problem:** Scripts don't have execute permission (644 instead of 755)
- **Fix:** `chmod +x start_app.sh database/setup_db.sh`
- **Symptom:** "Permission denied" when trying to run scripts
- **Unix Skills:** chmod, file permissions

### Issue #2: DOS Line Endings (Text Format)
- **Location:** `start_app.sh`
- **Problem:** Script has Windows CRLF line endings instead of Unix LF
- **Fix:** `dos2unix start_app.sh` or `sed -i 's/\r$//' start_app.sh`
- **Symptom:** "bad interpreter" or strange errors when running script
- **Unix Skills:** dos2unix, sed, file command

### Issue #3: Wrong Python Command (Command Path)
- **Location:** `start_app.sh` lines 23 and 47
- **Problem:** Script uses `python` instead of `python3`
- **Fix:** `sed -i 's/^python /python3 /' start_app.sh`
- **Symptom:** "Python is not installed or not in PATH" error
- **Unix Skills:** sed for text replacement

### Issue #4: Database Password (sed/awk)
- **Location:** `config/database.env` line 11
- **Problem:** Password is `BankSecure2024` but should be `BankSecure2024!`
- **Fix:** `sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' config/database.env`
- **Symptom:** Database authentication failure
- **Unix Skills:** sed, grep, text manipulation

### Issue #5: SQL Syntax Errors (Line-based Editing)
- **Location:** `database/init_db.sql` lines 10 and 22
- **Problem:** Missing semicolon and closing parenthesis
- **Fix:** `sed -i "10s/$/;/" database/init_db.sql` and line 22 fix
- **Symptom:** SQL parser errors
- **Unix Skills:** sed line-specific edits

### Issue #6: Wrong File Path (sed/grep)
- **Location:** `database/setup_db.sh` line 25
- **Problem:** References `init_db.sql` instead of `database/init_db.sql`
- **Fix:** `sed -i 's|init_db.sql|database/init_db.sql|' database/setup_db.sh`
- **Symptom:** File not found error
- **Unix Skills:** sed, path manipulation

### Issue #7: Wrong Variable Name (grep/sed)
- **Location:** `monitoring/health_check.sh` line 13
- **Problem:** Uses `$HEALTH_URL` instead of `$HEALTH_ENDPOINT`
- **Fix:** `sed -i 's/\$HEALTH_URL/\$HEALTH_ENDPOINT/g' monitoring/health_check.sh`
- **Symptom:** Empty variable, curl fails
- **Unix Skills:** grep to find, sed to replace

### Issue #8: Wrong Port Number (sed)
- **Location:** `start_app.sh` line 37
- **Problem:** Checking port 5433 instead of 5432
- **Fix:** `sed -i 's/5433/5432/g' start_app.sh`
- **Symptom:** Wrong warning about database
- **Unix Skills:** sed, pattern replacement

### Bonus Issues in Tools Scripts (Advanced)
- **parse_logs.sh**: Missing 'then', missing quote, incomplete grep/awk
- **validate_config.sh**: Wrong grep pattern for export statements
- **process_manager.sh**: Wrong signal (kill -9 instead of -TERM)

**Note**: The original Werkzeug version conflict bug has been removed as Flask and Werkzeug have been updated to secure, compatible versions (Flask 2.3.3, Werkzeug 2.3.7). The simulation now uses patched versions to address security vulnerabilities while maintaining all intended Unix learning objectives.

## Setup Instructions

### Prerequisites
Students' VM should have:
- Ubuntu 20.04+ or similar Linux distribution
- Python 3.8+
- PostgreSQL 12+
- Basic tools: curl, nc (netcat), git

### Quick Setup Commands

```bash
# Install required packages
sudo apt-get update
sudo apt-get install -y python3 python3-pip postgresql postgresql-contrib netcat

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Clone/copy the repository to VM
# Students should navigate to the directory
cd /path/to/banking-simulation
```

## Solution Steps (Expected Student Workflow)

### Phase 1: Initial Diagnosis (5-10 minutes)
1. **Read the scenario** (`SCENARIO.md`)
2. **Try to start the app** (`./start_app.sh`)
3. **Encounter first error**: Permission denied
4. **Run diagnostic tool**: `./diagnose.sh`

### Phase 2: Fix File Permissions (5 minutes)
```bash
# Check permissions
ls -l start_app.sh
file start_app.sh

# Fix permissions
chmod +x start_app.sh
chmod +x database/setup_db.sh monitoring/health_check.sh test_api.sh

# Or use find
find . -name "*.sh" -exec chmod +x {} \;
```

### Phase 3: Fix Line Endings (5 minutes)
```bash
# Detect DOS line endings
file start_app.sh

# Fix line endings
dos2unix start_app.sh
# OR
sed -i 's/\r$//' start_app.sh
```

### Phase 4: Fix Python Command (5 minutes)
```bash
# Find the problem
grep -n "^python " start_app.sh

# Fix using sed
sed -i 's/^python /python3 /' start_app.sh

# Verify
grep -n python start_app.sh
```

### Phase 5: Fix Database Password (10 minutes)
```bash
# Check current password
grep DB_PASSWORD config/database.env

# Check deployment notes for correct password
cat docs/DEPLOYMENT_NOTES.md | grep -i password

# Fix using sed
sed -i 's/BankSecure2024$/BankSecure2024!/' config/database.env

# Verify
source config/database.env
echo $DB_PASSWORD
```

### Phase 6: Fix SQL Script (10 minutes)
```bash
# Try to run database setup
cd database && sudo ./setup_db.sh

# Find syntax errors
cat init_db.sql | head -15

# Fix missing semicolon (line 10)
sed -i "10s/$/;/" init_db.sql

# Fix missing parenthesis (line 22)
sed -i "22s/TIMESTAMP$/TIMESTAMP)/" init_db.sql

# Fix setup script path
sed -i 's|init_db.sql|database/init_db.sql|' setup_db.sh
```

### Phase 7: Test and Verify (5 minutes)
```bash
# Initialize database
cd database && sudo ./setup_db.sh

# Install dependencies
pip3 install -r requirements.txt

# Start application
./start_app.sh

# Test health endpoint
curl http://localhost:8080/health

# Run full tests
./test_api.sh
```

## Time Estimates

- **Fast Students:** 20-30 minutes
- **Average Students:** 30-45 minutes
- **Struggling Students:** 45-60 minutes

## Evaluation Criteria

### Basic (Pass)
- [ ] Application starts without errors
- [ ] Database connection successful
- [ ] Health check endpoint responds
- [ ] Can document what was fixed

### Intermediate (Good)
- [ ] All basic criteria met
- [ ] Systematically used logs for troubleshooting
- [ ] Fixed issues in logical order
- [ ] Tested after each fix

### Advanced (Excellent)
- [ ] All intermediate criteria met
- [ ] Identified all bugs including optional ones
- [ ] Documented root cause analysis
- [ ] Suggested preventive measures
- [ ] Proper use of debugging tools

## Unix Commands Reference for Students

Provide these hints as needed:

### File Permissions
```bash
ls -l file.sh              # Check permissions
chmod +x file.sh           # Make executable
chmod 755 file.sh          # rwxr-xr-x
find . -name "*.sh"        # Find all shell scripts
```

### Text Search and Replace
```bash
grep "pattern" file        # Search for pattern
grep -r "pattern" dir/     # Recursive search
grep -n "pattern" file     # Show line numbers
sed 's/old/new/' file      # Replace first occurrence
sed 's/old/new/g' file     # Replace all occurrences
sed -i 's/old/new/g' file  # In-place replacement
```

### File Format and Encoding
```bash
file script.sh             # Check file type and encoding
dos2unix file              # Convert DOS to Unix
unix2dos file              # Convert Unix to DOS
sed 's/\r$//' file         # Remove carriage returns
```

### Environment Variables
```bash
env                        # Show all variables
echo $VAR                  # Show specific variable
export VAR=value           # Set variable
source file.env            # Load variables from file
```

### Process Management
```bash
ps aux | grep python       # Find processes
pgrep -f app.py           # Find process by name
kill PID                   # Stop process (SIGTERM)
kill -9 PID               # Force stop (SIGKILL)
lsof -i :8080             # Check what's using port
```

### Log Analysis
```bash
cat logs/app.log           # View entire log
tail -f logs/app.log       # Follow log in real-time
grep ERROR logs/app.log    # Find errors
grep -c ERROR logs/app.log # Count errors
awk '{print $1}' log       # Extract first column
```

## Hints to Give If Students Are Stuck

### Level 1 (After 15 minutes)
"Have you checked the application logs? They often contain clues about what's failing."

### Level 2 (After 30 minutes)
"Look at the deployment notes - what changed recently? Pay attention to passwords and configuration."

### Level 3 (After 45 minutes)
"Check the start_app.sh script carefully - are the commands correct for this system?"

## Extension Activities

For advanced students who finish early:

1. **Security Audit:** Identify security issues (debug mode on, no SSL, password in config file)
2. **Monitoring:** Set up proper monitoring and alerting
3. **Documentation:** Write runbook for this scenario
4. **Automation:** Create automated health checks
5. **Testing:** Write integration tests for the API

## Learning Objectives

After completing this exercise, students should be able to:

1. Read and interpret application logs
2. Troubleshoot database connectivity issues
3. Debug shell scripts
4. Understand configuration management
5. Use basic Linux troubleshooting tools
6. Follow a systematic debugging approach
7. Document issues and resolutions
8. Test and verify fixes

## Files Summary

- `SCENARIO.md` - Student-facing scenario description
- `app.py` - Main Python application (working correctly)
- `start_app.sh` - Startup script (contains bugs)
- `config/` - Configuration files (contains bugs)
- `database/` - Database setup scripts (contains bugs)
- `logs/` - Sample log files showing errors
- `monitoring/` - Health check scripts (contains bugs)
- `docs/` - API documentation and deployment notes
- `test_api.sh` - API testing script
- `requirements.txt` - Python dependencies (potential version issues)

## Troubleshooting the Simulation

If the simulation itself has issues:

1. Ensure PostgreSQL is properly installed and running
2. Python 3.8+ must be available as `python3`
3. All scripts need execute permissions
4. Port 8080 should be available
5. Student should have sudo access for database operations
