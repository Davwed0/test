# 🏦 MegaBank Advanced Unix/Linux Production Troubleshooting Challenge

## 📖 Overview

This is an **advanced, production-grade Unix/Linux troubleshooting simulation** for experienced system administrators. Students must diagnose and fix a complete banking system outage using **journalctl, lsof, systemd**, and advanced Unix diagnostic tools.

**Difficulty**: ⚠️ **HARD** - Requires advanced knowledge of systemd, log analysis, network diagnostics, and root cause analysis

**Perfect for**: Advanced Unix/Linux courses, SRE training, DevOps bootcamps, production support training

## 🎯 What Makes This Challenge HARD

Unlike simple tutorials, this simulation mirrors **real production outages**:

1. **No obvious error messages** - Must hunt through systemd journals and syslog
2. **Multiple cascading failures** - Fixing one reveals the next (6-7 layers deep)  
3. **Root cause analysis required** - Determine if issues are app, infrastructure, network, or database
4. **Real systemd service** - Actual service management, not just shell scripts
5. **Log archaeology** - Use journalctl, grep patterns, and lsof to find clues
6. **No hand-holding** - No diagnostic scripts or helpful error messages
7. **Time pressure** - Simulates real P1 production outage with SLA

## 🔥 Challenge Highlights

- **systemd service management** with intentional misconfigurations
- **journalctl log analysis** to find errors in system journals
- **Process/network diagnostics** using lsof, ss, netstat
- **Cascading failures** requiring iterative fix-test-repeat
- **App vs infrastructure differentiation** - Which layer is broken?
- **Production-grade logs** similar to real enterprise systems

## 🎯 Learning Objectives

Students will master:
- ✅ **journalctl & systemd**: Advanced service debugging
- ✅ **lsof, ss, netstat**: Network and process diagnostics
- ✅ **Root cause analysis**: App vs infra vs network vs DB
- ✅ **Log archaeology**: grep patterns in large log files
- ✅ **Cascading failures**: Iterative debugging methodology
- ✅ **Production troubleshooting**: Real P1 outage scenarios
- ✅ **Process management**: Finding and killing stale processes
- ✅ **Permissions & ownership**: systemd user contexts
- ✅ **Database connectivity**: PostgreSQL troubleshooting

## ⏱️ Time Estimates

This is **significantly harder** than typical tutorials:

- **Experienced sysadmins**: 60-90 minutes
- **Advanced students**: 90-120 minutes
- **With progressive hints**: 120+ minutes

## 🚀 Quick Start

### For Students (HARD Mode)

```bash
# Read the P1 outage scenario
cat ADVANCED_SCENARIO.md

# Try to understand what's broken
sudo systemctl status megabank-api

# Check the logs
sudo journalctl -u megabank-api --since "1 hour ago"

# Start your investigation...
```

### For Instructors

```bash
# Install the broken service
sudo ./manage-service.sh install

# Service will be in failed state (this is correct)
sudo systemctl status megabank-api

# See ADVANCED_INSTRUCTOR_GUIDE.md for the complete solution
```

### For Students (EASY Mode - Original Challenge)

```bash
# Use the simpler version
./start_app.sh
cat SCENARIO.md
```

## 📁 File Structure

```
📄 ADVANCED MODE (HARD):
   ADVANCED_SCENARIO.md              - ⭐ P1 production outage scenario
   ADVANCED_INSTRUCTOR_GUIDE.md      - Complete solution with cascading failures
   network-diagnostics.sh             - Network/process diagnostic tool
   manage-service.sh                  - systemd service management
   systemd/megabank-api.service       - systemd unit file (buggy)
   sample-logs/                       - Reference logs

📄 EASY MODE (Original):
   SCENARIO.md                        - Simpler troubleshooting scenario
   INSTRUCTOR_GUIDE.md                - Solutions for easy mode
   diagnose.sh                        - Helper diagnostic script
   start_app.sh                       - Simple startup script

📁 Application:
   app.py                             - Banking API (uses syslog)
   config/                            - Configuration files
   database/                          - Database scripts
   requirements.txt                   - Python dependencies
```

## 🐛 Types of Issues (Advanced Mode)

Students will encounter cascading failures:

1. **systemd exec failure** (status=203/EXEC)
2. **File permissions** and ownership issues
3. **Configuration** file location/format problems
4. **Database authentication** failures
5. **Port conflicts** with stale processes
6. **Database connectivity** issues
7. **Application runtime** errors

**Each fix reveals the next issue** - students must iterate through logs repeatedly.

## 🛠️ Essential Commands Students Need

### Log Analysis (CRITICAL)
```bash
sudo journalctl -u megabank-api              # Service-specific logs
sudo journalctl -u megabank-api --since "1 hour ago"
sudo journalctl -xe                          # Recent system errors
sudo tail -f /var/log/syslog | grep megabank
```

### Network Diagnostics  
```bash
sudo lsof -i :8080                           # What's using port 8080?
sudo ss -tlnp | grep 8080
sudo netstat -tlnp | grep 8080
nc -zv localhost 5432                        # Test DB connection
```

### Service Management
```bash
sudo systemctl status megabank-api
sudo systemctl start megabank-api
sudo systemctl daemon-reload
sudo systemctl cat megabank-api              # View unit file
```

### Process Management
```bash
ps aux | grep megabank
sudo lsof -u bankapp                         # Files opened by user
sudo kill -9 <PID>                           # Kill stale process
```

## ✅ Success Criteria

The challenge is complete when:

1. Service starts: `sudo systemctl start megabank-api` succeeds
2. Status is active: `sudo systemctl status megabank-api` shows "active (running)"
3. Port is bound: `sudo lsof -i :8080` shows the service listening
4. Database connected: Logs show successful database connection
5. Health check works: `curl http://localhost:8080/health` returns 200
6. API responds: `curl http://localhost:8080/api/status` returns data

**Plus**: Student documents each failure, root cause, and fix applied

## 📚 Documentation

- **ADVANCED_SCENARIO.md**: Start here for the hard challenge
- **ADVANCED_INSTRUCTOR_GUIDE.md**: Complete walkthrough of all cascading failures
- **SCENARIO.md**: Easier version for beginners
- **UNIX_EXERCISES.md**: Unix command reference and examples

## 🎓 Grading Rubric (Advanced Mode)

### Basic (60-70%)
- Got service running
- Used journalctl to find errors
- Fixed major blocking issues

### Good (70-85%)  
- Systematic approach
- Used lsof/ss/netstat correctly
- Fixed issues in logical order
- Documented major steps

### Excellent (85-95%)
- Advanced log analysis with grep
- Root cause analysis for each issue
- Distinguished app vs infra vs network vs DB
- Comprehensive documentation

### Outstanding (95-100%)
- Created troubleshooting runbook
- Identified preventive measures
- Suggested monitoring improvements
- Automation script for diagnostics

## 🔒 Security Note

This is a **training simulation** with intentionally broken configurations. Do not use in production!

## 📦 Deployment

### Prerequisites
```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip postgresql systemd lsof net-tools
```

### Setup
```bash
git clone <repo> banking-simulation
cd banking-simulation
sudo ./manage-service.sh install
```

## 💡 Teaching Strategy

1. **First 15 min**: Let students struggle with journalctl
2. **After 30 min**: Hint about systemd service file paths
3. **After 45 min**: Remind about file permissions for service users
4. **After 60 min**: Suggest checking for port conflicts with lsof
5. **After 90 min**: Verify PostgreSQL is running

**Key**: Don't give solutions, guide them to diagnostic tools

---

**Created for production-grade Unix/Linux training** 🚀

Choose your difficulty:
- **HARD**: Start with `ADVANCED_SCENARIO.md` 
- **EASY**: Start with `SCENARIO.md`
