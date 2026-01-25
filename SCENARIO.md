# Unix System Administration Challenge - Banking Application

## Situation Brief

You are a **Unix System Administrator** at **MegaBank International**. It's Monday morning, 8:00 AM, and you've received an urgent ticket:

```
TICKET #2024-10567 - CRITICAL - P1
Subject: Banking System Completely Down - Unix Issues
Reporter: Sarah Chen (Operations Manager)
Time: 07:45 AM

The banking system went down after Friday's deployment by a junior 
DevOps engineer who is now on vacation. Multiple Unix-level issues 
are preventing the system from starting:

- Scripts won't execute
- Configuration files appear corrupted
- File permissions are wrong
- Processes aren't starting correctly
- Log files show encoding issues

The deployment team made changes but didn't properly test on Linux.
We need someone with strong Unix skills to fix this ASAP.

IMPACT: 50,000+ customers affected
SLA: Must be resolved within 2 hours
SKILLS NEEDED: grep, sed, awk, bash scripting, file permissions
```

## Your Mission

You need to use Unix command-line tools to:
1. Debug shell scripts with syntax errors
2. Fix file permission and ownership issues
3. Use grep/sed/awk to repair configuration files
4. Handle text encoding problems (DOS vs Unix line endings)
5. Manage processes and environment variables
6. Parse and analyze log files
7. Get the system running successfully
8. Document all Unix commands you used

## Environment

- **Server**: Ubuntu Linux VM
- **Application**: Python-based Banking API
- **Database**: PostgreSQL
- **Port**: 8080
- **Config Location**: `/config/`
- **Logs Location**: `/logs/`

## Getting Started

1. Navigate to the application directory
2. Try to start the application: `./start_app.sh`
3. Check logs if it fails: `cat logs/app.log`
4. Investigate and fix issues one by one
5. Test the API endpoints when running

## Success Criteria

The application should:
- Start without errors
- Connect to the database successfully
- Respond to health check: `curl http://localhost:8080/health`
- Handle basic API requests

## Unix Skills You'll Need

- **grep**: Search for patterns in files
- **sed**: Stream editor for text manipulation
- **awk**: Text processing and data extraction
- **find**: Locate files in directory hierarchies
- **chmod/chown**: Fix file permissions and ownership
- **ps/kill**: Process management
- **dos2unix**: Fix line ending issues
- **source**: Load environment variables
- **bash debugging**: Fix script syntax errors
- **cat/head/tail**: Log file analysis

## Time Limit

You have 2 hours (in real scenario) - try to complete in 30-60 minutes for this exercise.

Good luck! The customers are counting on you! 🏦
