# Advanced Unix System Administration Challenge - MegaBank Production Outage

## Situation Brief - CRITICAL PRODUCTION OUTAGE

You are a **Senior Unix System Administrator** at **MegaBank International**. Monday morning, 8:15 AM - You've been called in for a P1 production outage:

```
TICKET #2024-10567 - CRITICAL - P1 - PRODUCTION DOWN
Subject: Complete Banking System Failure - All Services Down
Reporter: Sarah Chen (VP of Operations)
Time: 08:05 AM
Priority: CRITICAL - Revenue Impact $50K/minute

SITUATION:
The core banking API (megabank-api.service) has been down since 07:30 AM.
A junior DevOps engineer attempted a deployment Friday evening and is now
unreachable (vacation in remote area, no cell service).

SYMPTOMS REPORTED:
- Service won't start via systemd
- Customers cannot access any banking functions
- Monitoring shows service in failed state
- No application logs visible in usual locations
- Previous engineer's notes are incomplete

IMPACT:
- 50,000+ customers affected
- $3M/hour revenue loss
- Regulatory reporting deadline in 4 hours
- Media starting to report outages

YOUR MISSION:
Use advanced Unix troubleshooting to:
1. Locate and analyze system logs (journalctl, syslog, application logs)
2. Determine root cause (application vs infrastructure vs network)
3. Identify ALL blocking issues (there are multiple cascading failures)
4. Fix each issue systematically
5. Verify service is fully operational
6. Document your investigation and remediation steps

SLA: Service must be restored within 2 hours
CONSTRAINTS: You have sudo access but limited documentation
```

## What Makes This HARD

This is NOT a simple "fix permissions and restart" scenario. You must:

### 1. Log Investigation (30-40% of the challenge)
- **Find logs**: Service logs are NOT in obvious locations
  - Use `sudo journalctl -u megabank-api` for systemd logs
  - Use `lsof` to find what files the service would open
  - Check `/var/log/syslog` or `/var/log/messages` for system-level errors
  - Use `sudo journalctl -xe` for recent errors across all services
  - Application logs may be in `/var/log/megabank/` (if service ever started)

- **Analyze errors**: Logs contain red herrings and multiple error types
  - systemd exec errors (status=203/EXEC)
  - Database authentication failures
  - Port binding conflicts
  - File permission issues
  - Network connectivity problems

- **Pattern matching**: Use complex grep to isolate issues
  ```bash
  # Find all errors in last hour
  sudo journalctl -u megabank-api --since "1 hour ago" | grep -i error
  
  # Find specific error codes
  sudo journalctl -u megabank-api | grep "status=203"
  
  # Check for database errors
  sudo journalctl | grep -i "postgres" | grep -i "error"
  ```

### 2. Root Cause Analysis (20-30% of the challenge)
Determine if each failure is:
- **Application Issue**: Code bugs, missing files, wrong paths
- **Infrastructure Issue**: systemd config, file permissions, missing directories
- **Network Issue**: Port conflicts, firewall, connectivity
- **Database Issue**: Authentication, connectivity, service not running

Tools you'll need:
```bash
# Check service status
sudo systemctl status megabank-api
sudo systemctl list-units --failed

# Check what's using ports
sudo lsof -i :8080
sudo ss -tlnp | grep 8080
sudo netstat -tlnp | grep 8080

# Check database connectivity
sudo systemctl status postgresql
nc -zv localhost 5432
psql -h localhost -U bank_user -d banking_db -c "SELECT 1"

# Check file existence and permissions
sudo ls -la /opt/megabank/
sudo ls -la /etc/megabank/
sudo ls -la /var/log/megabank/

# Check process ownership
ps aux | grep megabank
sudo -u bankapp ls /opt/megabank/
```

### 3. Cascading Failures (30-40% of the challenge)
Issues must be fixed **in order**. Fixing one reveals the next:

**Failure Chain** (Students must discover this):
1. **systemd exec failure** → Wrong file path in service unit
2. **After fixing path** → File permissions prevent execution
3. **After fixing permissions** → Configuration file missing/wrong location
4. **After fixing config** → Database password authentication fails
5. **After fixing password** → Port already in use by stale process
6. **After killing process** → Database not accepting connections
7. **After fixing database** → Application finally starts
8. **After starting** → Need to verify it's actually working

Each fix requires:
- Analyzing logs to understand the error
- Identifying the root cause
- Applying the fix
- Restarting and checking logs again
- Moving to next issue

### 4. No Hand-Holding
- No `diagnose.sh` script to help you
- No simple error messages pointing to solutions
- Must read actual systemd/syslog entries
- Must understand error codes (203/EXEC, EADDRINUSE, etc.)
- Must use professional troubleshooting methodology

## Required Unix Skills

### Essential Commands:
```bash
# Log Analysis (CRITICAL)
sudo journalctl -u megabank-api
sudo journalctl -u megabank-api --since "today"
sudo journalctl -xe
sudo tail -f /var/log/syslog
sudo grep "megabank" /var/log/syslog
sudo journalctl | grep -i "error" | grep -i "banking"

# Service Management
sudo systemctl status megabank-api
sudo systemctl start megabank-api
sudo systemctl restart megabank-api
sudo systemctl daemon-reload
sudo systemctl cat megabank-api

# Process Investigation
ps aux | grep megabank
ps aux | grep 8080
sudo lsof -i :8080
sudo lsof -u bankapp
sudo lsof -p <PID>
pgrep -f megabank
sudo kill -9 <PID>

# Network Diagnostics
sudo ss -tlnp
sudo netstat -tlnp
nc -zv localhost 5432
nc -zv localhost 8080
telnet localhost 8080

# File System
sudo ls -la /opt/megabank/
sudo find /etc -name "*megabank*"
sudo find /var/log -name "*megabank*"
stat /opt/megabank/banking-api.py

# Permissions & Ownership
sudo chmod +x /opt/megabank/banking-api.py
sudo chown bankapp:bankapp /opt/megabank/*
sudo chmod 755 /opt/megabank/
sudo chmod 644 /etc/megabank/database.conf

# Database
sudo systemctl status postgresql
sudo -u postgres psql -l
psql -h localhost -U bank_user -d banking_db
sudo -u postgres psql -c "ALTER USER bank_user WITH PASSWORD 'newpass';"
```

### Advanced Techniques:
```bash
# Trace service startup to see where it fails
sudo journalctl -u megabank-api -f

# Check systemd unit file for errors
sudo systemctl cat megabank-api
sudo vim /etc/systemd/system/megabank-api.service

# Find all megabank-related processes and files
sudo find / -name "*megabank*" 2>/dev/null
ps aux | grep -E "(megabank|8080|bank)"

# Check environment variables service uses
sudo systemctl show megabank-api | grep Env
cat /etc/megabank/database.conf

# Test database connection manually
psql -h localhost -U bank_user -d banking_db -c "\dt"

# Monitor in real-time while attempting start
watch -n 1 'sudo systemctl status megabank-api'

# Check for SELinux/AppArmor denials (advanced)
sudo ausearch -m avc -ts recent
sudo dmesg | grep -i denied
```

## Success Criteria

### Service Must:
1. Start successfully via `sudo systemctl start megabank-api`
2. Show status as `active (running)` in systemctl status
3. Bind to port 8080 and accept connections
4. Connect to PostgreSQL database successfully
5. Respond to health check: `curl http://localhost:8080/health`
6. Process actual API requests: `curl http://localhost:8080/api/status`

### You Must Document:
1. Each error you found (with grep/journalctl commands used)
2. Root cause of each issue
3. How you determined if it was app/infra/network/database
4. The fix applied for each issue
5. Verification steps after each fix

## Time Estimate

- **Beginner** (with some hints): 90-120 minutes
- **Intermediate**: 60-90 minutes
- **Advanced**: 45-60 minutes

This is a **realistic production troubleshooting scenario**. In the real world, you would:
- Have pressure from management
- Need to update stakeholders while investigating
- Document everything for post-mortem
- Possibly page other teams (database, network, security)

Good luck. The customers - and your job - depend on you. 🏦⚡

## Getting Started

```bash
# First steps - understand the failure
sudo systemctl status megabank-api

# Check recent systemd logs
sudo journalctl -u megabank-api --since "1 hour ago"

# Check system logs
sudo tail -100 /var/log/syslog | grep megabank

# Now start your investigation...
```
