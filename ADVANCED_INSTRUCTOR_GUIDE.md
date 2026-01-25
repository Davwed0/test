# ADVANCED Instructor Guide - Production Troubleshooting Challenge

## Overview

This is a **significantly harder** version focusing on realistic production troubleshooting with:
- Systemd service management
- Log analysis with journalctl and syslog
- Process and network diagnostics with lsof, ss, netstat
- Cascading failures requiring iterative fix-test-repeat cycles
- Application vs infrastructure vs network root cause analysis

## Difficulty Level: HARD / ADVANCED

Students MUST:
- Know how to use journalctl effectively
- Understand systemd service management
- Use lsof and ss/netstat for network diagnostics
- Analyze complex log files with grep
- Distinguish between different failure types
- Work through multiple cascading issues

## Setup Instructions for Instructors

### 1. Initial Setup (Run as root/sudo)

```bash
cd /path/to/banking-simulation

# Install the systemd service
sudo ./manage-service.sh install

# This creates:
# - /etc/systemd/system/megabank-api.service
# - /opt/megabank/ (application directory)
# - /etc/megabank/ (configuration)
# - /var/log/megabank/ (logs)
# - User 'bankapp' for service

# Intentionally break things (bugs are already in place)
# The service WILL fail to start - this is intentional
```

### 2. Place Sample Logs (for reference)

```bash
# Copy sample logs to show students what "good" logs look like
sudo cp sample-logs/syslog.sample /var/log/megabank/syslog.reference
sudo cp sample-logs/megabank-detailed.log /var/log/megabank/successful-start.reference
```

### 3. Verify Setup

```bash
# Service should be in failed state
sudo systemctl status megabank-api
# Expected: Failed (this is correct for the challenge)

# Logs should show errors
sudo journalctl -u megabank-api
```

## Cascading Failure Chain (What Students Will Encounter)

### Issue #1: systemd Exec Failure (status=203/EXEC)

**How Student Discovers:**
```bash
sudo systemctl status megabank-api
# Shows: Main process exited, code=exited, status=203/EXEC

sudo journalctl -u megabank-api --since "1 hour ago"
# Shows repeated 203/EXEC failures
```

**Root Cause:**
- systemd unit file has wrong path: `/opt/megabank/banking-api.py`
- Actual file is at: `/opt/megabank/app.py`

**Location:** `/etc/systemd/system/megabank-api.service` line 11

**How to Fix:**
```bash
sudo vim /etc/systemd/system/megabank-api.service
# Change ExecStart=/usr/bin/python3 /opt/megabank/banking-api.py
# To:     ExecStart=/usr/bin/python3 /opt/megabank/app.py

sudo systemctl daemon-reload
sudo systemctl start megabank-api
```

**Verification:**
```bash
sudo journalctl -u megabank-api -n 20
# Should now show different error (not 203/EXEC)
```

### Issue #2: File Permissions Error

**How Student Discovers:**
```bash
sudo journalctl -u megabank-api
# May show: Permission denied errors
# OR: Python import errors
# OR: Cannot read configuration file

sudo ls -la /opt/megabank/
# Shows wrong permissions on app.py

sudo systemctl cat megabank-api
# See that service runs as user 'bankapp'

# Check if bankapp can access files
sudo -u bankapp ls /opt/megabank/
# May fail or show insufficient permissions
```

**Root Cause:**
- Files in /opt/megabank/ have wrong ownership/permissions
- Service runs as 'bankapp' user
- Files may be owned by root or have wrong permissions

**How to Fix:**
```bash
sudo chown -R bankapp:bankapp /opt/megabank/
sudo chmod 755 /opt/megabank/
sudo chmod 644 /opt/megabank/*.py
sudo chmod 755 /opt/megabank/app.py  # Make executable if needed

# Also fix log directory
sudo chown -R bankapp:bankapp /var/log/megabank/
sudo chmod 755 /var/log/megabank/
```

**Verification:**
```bash
sudo systemctl start megabank-api
sudo journalctl -u megabank-api -n 20
```

### Issue #3: Configuration File Missing or Wrong

**How Student Discovers:**
```bash
sudo journalctl -u megabank-api
# Shows: Cannot load configuration
# OR: KeyError for environment variables
# OR: Database connection has wrong/missing credentials

sudo systemctl cat megabank-api
# Shows: EnvironmentFile=/etc/megabank/database.conf

sudo ls -la /etc/megabank/
# File might be named wrong (database.env vs database.conf)
```

**Root Cause:**
- Config file is `/etc/megabank/database.env` 
- systemd expects `/etc/megabank/database.conf`
- OR environment variables not properly exported

**How to Fix:**
```bash
# Option 1: Rename file
sudo mv /etc/megabank/database.env /etc/megabank/database.conf

# Option 2: Update systemd service file
sudo vim /etc/systemd/system/megabank-api.service
# Change EnvironmentFile path

# Fix environment variable format (must not have 'export')
sudo vim /etc/megabank/database.conf
# Remove 'export' from each line
# Change: export DB_HOST=localhost
# To:     DB_HOST=localhost

sudo systemctl daemon-reload
sudo systemctl restart megabank-api
```

**Verification:**
```bash
sudo journalctl -u megabank-api -n 30
```

### Issue #4: Database Password Authentication

**How Student Discovers:**
```bash
sudo journalctl -u megabank-api
# Shows: password authentication failed for user "bank_user"
# Shows: FATAL: password authentication failed

# Can also check application-specific logs if they exist
sudo tail -50 /var/log/megabank/app.log 2>/dev/null
```

**Root Cause:**
- Database password in config is wrong
- Password should be `BankSecure2024!` but is `BankSecure2024`

**How to Fix:**
```bash
sudo vim /etc/megabank/database.conf
# Find: DB_PASSWORD=BankSecure2024
# Change to: DB_PASSWORD=BankSecure2024!

# OR use sed
sudo sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' /etc/megabank/database.conf

sudo systemctl restart megabank-api
```

**Verification:**
```bash
sudo journalctl -u megabank-api -n 20
# Should show database connection successful
```

### Issue #5: Port Already in Use

**How Student Discovers:**
```bash
sudo journalctl -u megabank-api
# Shows: Address already in use
# Shows: Failed to bind to port 8080
# Shows: OSError: [Errno 98] Address already in use

# Check what's using port
sudo lsof -i :8080
sudo ss -tlnp | grep 8080
sudo netstat -tlnp | grep 8080
```

**Root Cause:**
- Previous failed attempt left a Python process running
- OR another service is using port 8080
- Need to kill the conflicting process

**How to Fix:**
```bash
# Find process using port 8080
sudo lsof -i :8080
# Note the PID

# Kill the process
sudo kill -9 <PID>

# OR kill all python processes (careful!)
sudo pkill -9 python3

# Verify port is free
sudo lsof -i :8080
# Should return nothing

sudo systemctl start megabank-api
```

**Verification:**
```bash
sudo systemctl status megabank-api
sudo lsof -i :8080
# Should show bankapp's megabank process
```

### Issue #6: Database Not Running/Accepting Connections

**How Student Discovers:**
```bash
sudo journalctl -u megabank-api
# Shows: could not connect to server
# Shows: Connection refused
# Shows: Is the server running?

# Check database status
sudo systemctl status postgresql
# May show: inactive (dead) or failed

# Test connection manually
nc -zv localhost 5432
# Connection refused

# Check if database is listening
sudo ss -tlnp | grep 5432
# Nothing shown
```

**Root Cause:**
- PostgreSQL service is not running
- OR database is not configured to accept connections
- OR database is running but not listening on localhost

**How to Fix:**
```bash
# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Verify it's running
sudo systemctl status postgresql

# Test connection
nc -zv localhost 5432
# Connection successful

# If database user doesn't exist or needs password reset
sudo -u postgres psql <<EOF
ALTER USER bank_user WITH PASSWORD 'BankSecure2024!';
EOF

sudo systemctl restart megabank-api
```

**Verification:**
```bash
sudo journalctl -u megabank-api -n 20
# Should show successful database connection
sudo systemctl status megabank-api
# Should show active (running)
```

### Issue #7: Final Verification - Application Not Responding

**How Student Discovers:**
```bash
sudo systemctl status megabank-api
# Shows: active (running)

# But curl fails
curl http://localhost:8080/health
# Connection refused OR timeout

# Check if process is actually listening
sudo lsof -i :8080
# Shows process but not LISTEN state

# Check application logs
sudo journalctl -u megabank-api -n 50
# Shows errors after startup
```

**Possible Root Causes:**
- Application started but crashed immediately
- Firewall blocking connections
- Application bound to wrong interface
- Import errors in Python code

**How to Fix:**
```bash
# Check detailed logs
sudo journalctl -u megabank-api -n 100 | less

# If Python import errors - missing dependencies
sudo pip3 install -r /opt/megabank/requirements.txt

# If firewall issue
sudo ufw allow 8080/tcp
# OR
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

# Restart service
sudo systemctl restart megabank-api

# Wait a few seconds for startup
sleep 5

# Test
curl http://localhost:8080/health
```

## Complete Solution Path

```bash
# 1. Check service status
sudo systemctl status megabank-api

# 2. Check logs for errors
sudo journalctl -u megabank-api --since "1 hour ago"

# 3. Fix systemd service file path
sudo sed -i 's|/opt/megabank/banking-api.py|/opt/megabank/app.py|' /etc/systemd/system/megabank-api.service
sudo systemctl daemon-reload

# 4. Fix file permissions
sudo chown -R bankapp:bankapp /opt/megabank/
sudo chown -R bankapp:bankapp /var/log/megabank/
sudo chmod 755 /opt/megabank/
sudo chmod 644 /opt/megabank/*.py

# 5. Fix configuration file name and format
sudo cp /etc/megabank/database.env /etc/megabank/database.conf
sudo sed -i 's/^export //' /etc/megabank/database.conf

# 6. Fix database password
sudo sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' /etc/megabank/database.conf

# 7. Kill any processes using port 8080
sudo kill -9 $(sudo lsof -t -i:8080) 2>/dev/null || true

# 8. Ensure PostgreSQL is running
sudo systemctl start postgresql

# 9. Install Python dependencies
sudo pip3 install -r /opt/megabank/requirements.txt

# 10. Start service
sudo systemctl start megabank-api

# 11. Verify
sudo systemctl status megabank-api
curl http://localhost:8080/health
```

## Grading Rubric (Advanced)

### Basic (60-70%) - Service Running
- Successfully got service to start
- Used journalctl to find some errors
- Fixed major blocking issues
- Service responds to health check

### Good (70-85%) - Systematic Approach
- All basic requirements
- Used lsof/ss/netstat for network diagnostics
- Distinguished between different error types
- Fixed issues in logical order
- Documented major steps

### Excellent (85-95%) - Professional Troubleshooting
- All good requirements
- Advanced log analysis (complex grep patterns)
- Root cause analysis for each issue
- Clear differentiation: app vs infra vs network vs DB issues
- Comprehensive documentation
- Used multiple diagnostic tools appropriately

### Outstanding (95-100%) - Expert Level
- All excellent requirements
- Created troubleshooting runbook
- Identified process improvements to prevent issues
- Suggested monitoring/alerting improvements
- Automation script for common diagnostic steps
- Post-mortem analysis document

## Time Estimates

- **With hints every 15 min**: 90-120 minutes
- **Minimal hints**: 60-90 minutes
- **Advanced students**: 45-60 minutes
- **Expert (has done this before)**: 30-45 minutes

## Hints to Provide (Progressive)

### After 15 minutes:
"Start with `sudo journalctl -u megabank-api` - what does the error code 203 mean?"

### After 30 minutes:
"Check the systemd service file with `sudo systemctl cat megabank-api`. Is the file path correct?"

### After 45 minutes:
"Use `sudo lsof -i :8080` to see what's using the port. You may need to kill stale processes."

### After 60 minutes:
"Remember to check if PostgreSQL is running with `sudo systemctl status postgresql`"

## Common Student Mistakes

1. **Not using sudo**: Many commands require root/sudo
2. **Not reloading systemd**: After editing service files, must run `daemon-reload`
3. **Wrong user context**: Files must be readable by 'bankapp' user
4. **Not checking previous issues**: Fixing one issue reveals the next - must iterate
5. **Ignoring environment file format**: systemd EnvironmentFile can't have 'export'
6. **Not killing stale processes**: Old attempts leave processes on port 8080
7. **Not waiting for service startup**: Checking too quickly after restart

## Additional Challenges (Optional)

For students who finish early:

1. **Create monitoring script** that checks service health every minute
2. **Write post-mortem** explaining what went wrong and how to prevent it
3. **Create automated fix script** that can detect and fix common issues
4. **Set up log rotation** for /var/log/megabank/
5. **Configure systemd email alerts** for service failures
6. **Create dashboard** showing service status, port usage, database connectivity

This is a **production-ready troubleshooting challenge** that mirrors real-world scenarios!
