# MegaBank Unix Challenge - Two Difficulty Modes

## Overview

This repository now contains **TWO** versions of the Unix troubleshooting challenge:

### 🟢 EASY MODE (Original)
Basic Unix skills - File permissions, text processing, simple scripting
**Time**: 30-60 minutes

### 🔴 HARD MODE (New - Advanced Production Troubleshooting)
Advanced production troubleshooting - systemd, journalctl, lsof, cascading failures
**Time**: 60-120 minutes

---

## 🟢 EASY MODE - File & Script Troubleshooting

### Start Here:
- Read: `SCENARIO.md`
- Solutions: `INSTRUCTOR_GUIDE.md`
- Helper: `diagnose.sh`

### What Students Learn:
- File permissions (chmod)
- DOS line endings (dos2unix)
- Text processing (sed, awk, grep)
- Environment variables
- Basic process management

### Issues to Fix (8 simple bugs):
1. Scripts not executable
2. DOS CRLF line endings
3. Wrong Python command (python vs python3)
4. Database password typo
5. SQL syntax errors
6. Wrong file paths
7. Variable name typos
8. Port number mistakes

### Approach:
- Run `./diagnose.sh` to see what's broken
- Fix issues one by one using sed/chmod
- Application starts after all fixes

---

## 🔴 HARD MODE - Production Troubleshooting

### Start Here:
- Read: `ADVANCED_SCENARIO.md`
- Solutions: `ADVANCED_INSTRUCTOR_GUIDE.md`
- Setup: `sudo ./manage-service.sh install`

### What Students Learn:
- systemd service management
- journalctl log analysis
- lsof/ss/netstat for network diagnostics
- Root cause analysis (app vs infra vs network vs DB)
- Cascading failure diagnosis
- Production troubleshooting methodology

### Cascading Failures (6-7 layers):
Each fix reveals the next issue - students must iterate:

1. **systemd exec failure** (status=203/EXEC)
   - Tool: `sudo journalctl -u megabank-api`
   - Issue: Wrong file path in service unit
   
2. **File permissions**
   - Tool: `sudo ls -la /opt/megabank/`
   - Issue: Service runs as 'bankapp' user, can't access files
   
3. **Configuration missing**
   - Tool: `sudo systemctl cat megabank-api`
   - Issue: Wrong config file location/format
   
4. **Database authentication**
   - Tool: `sudo journalctl -u megabank-api | grep -i error`
   - Issue: Password wrong in config
   
5. **Port conflict**
   - Tool: `sudo lsof -i :8080`
   - Issue: Stale process using port 8080
   
6. **Database not running**
   - Tool: `nc -zv localhost 5432`
   - Issue: PostgreSQL service stopped
   
7. **Final verification**
   - Tool: `curl http://localhost:8080/health`
   - Issue: May have remaining runtime errors

### Approach:
- **NO helper scripts** - students must figure it out
- Use journalctl to find errors
- Use lsof to diagnose network issues
- Fix one issue at a time
- Recheck logs after each fix
- Repeat until service works

### Required Commands:
```bash
# Log analysis
sudo journalctl -u megabank-api
sudo journalctl -xe
sudo tail -f /var/log/syslog

# Network diagnostics
sudo lsof -i :8080
sudo ss -tlnp | grep 8080
nc -zv localhost 5432

# Service management
sudo systemctl status megabank-api
sudo systemctl daemon-reload
sudo systemctl cat megabank-api

# Process management
ps aux | grep megabank
sudo kill -9 <PID>
```

---

## 📊 Comparison Table

| Feature | Easy Mode | Hard Mode |
|---------|-----------|-----------|
| **Difficulty** | Beginner/Intermediate | Advanced |
| **Time** | 30-60 min | 60-120 min |
| **Service Type** | Shell script | systemd service |
| **Logs** | Simple files in logs/ | journalctl + syslog |
| **Helper Tools** | diagnose.sh | None (students must use lsof/journalctl) |
| **Issues** | 8 independent bugs | 6-7 cascading failures |
| **Debugging** | Linear (fix all, then run) | Iterative (fix-test-repeat) |
| **Root Cause** | Obvious from errors | Must analyze and determine |
| **Network Tools** | Basic (nc) | Advanced (lsof, ss, netstat) |
| **Real World** | Learning exercise | Production simulation |

---

## 🎓 Which Mode to Use?

### Use EASY MODE for:
- Introduction to Unix basics
- First-time system administrators
- Focus on file permissions and text processing
- Students with limited Linux experience
- Time-constrained workshops (< 1 hour)

### Use HARD MODE for:
- Advanced Unix/Linux courses
- SRE/DevOps training
- Production support training
- Experienced students needing challenge
- Interview preparation for sysadmin roles
- Multi-hour workshops (2-3 hours)

---

## 📁 File Guide

### Easy Mode Files:
- `SCENARIO.md` - Simple troubleshooting scenario
- `INSTRUCTOR_GUIDE.md` - Solutions for easy mode
- `UNIX_EXERCISES.md` - Command examples
- `diagnose.sh` - Helper diagnostic tool
- `start_app.sh` - Simple startup script
- `FIX_ALL.sh` - Auto-fix all issues

### Hard Mode Files:
- `ADVANCED_SCENARIO.md` - P1 production outage
- `ADVANCED_INSTRUCTOR_GUIDE.md` - Complete walkthrough
- `README_ADVANCED.md` - Advanced mode documentation
- `systemd/megabank-api.service` - systemd unit file
- `manage-service.sh` - Service management tool
- `network-diagnostics.sh` - Network diagnostic tool
- `sample-logs/` - Reference logs

### Shared Files:
- `app.py` - Banking API (works with both modes)
- `config/` - Configuration files
- `database/` - Database scripts
- `requirements.txt` - Python dependencies

---

## 🚀 Quick Start

### Easy Mode:
```bash
cd banking-simulation
./start_app.sh
# Will fail - follow SCENARIO.md to fix
```

### Hard Mode:
```bash
cd banking-simulation
sudo ./manage-service.sh install
sudo systemctl status megabank-api
# Will be failed - follow ADVANCED_SCENARIO.md
```

---

## 💡 Teaching Tips

### For Easy Mode:
- Students can work independently
- Provide UNIX_EXERCISES.md as reference
- Let them use diagnose.sh after 15 minutes
- Expect completion in one session

### For Hard Mode:
- Brief students on P1 outage pressure
- Emphasize iterative debugging
- Don't give solutions - guide to tools
- Progressive hints every 20-30 minutes:
  - 20 min: "Check journalctl for the service"
  - 40 min: "Is the file path in the service correct?"
  - 60 min: "Use lsof to check what's on port 8080"
  - 80 min: "Is PostgreSQL running?"
- May need multiple sessions or homework

---

## 🎯 Learning Outcomes

### After Easy Mode, students can:
- Use chmod to fix permissions
- Convert line endings with dos2unix
- Edit files with sed and awk
- Debug simple shell scripts
- Manage environment variables

### After Hard Mode, students can:
- Troubleshoot systemd services
- Analyze logs with journalctl
- Diagnose network issues with lsof/ss/netstat
- Perform root cause analysis
- Handle cascading failures
- Work under P1 outage pressure
- Document troubleshooting steps

---

## 📝 Summary

**Easy Mode** = Learning Unix basics through guided exercise
**Hard Mode** = Simulating real production outage with no hand-holding

Both modes use the same application, just different deployment and troubleshooting approaches!

Choose based on your students' experience level and learning objectives.
