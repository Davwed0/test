# Quick Setup Guide for VM Deployment

## For Instructors: How to Deploy This Simulation

### Option 1: Clone from GitHub (Recommended)

```bash
# On the student VM
cd /home/student  # or wherever you want
git clone https://github.com/Davwed0/test.git banking-simulation
cd banking-simulation
```

### Option 2: Manual Copy

1. Download the repository as ZIP
2. Extract to the VM
3. Place in `/home/student/banking-simulation/`

### Option 3: Create from Scratch

Copy the entire directory structure from this repository to your VM.

## VM Prerequisites

Students need a Linux VM with:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
    python3 \
    python3-pip \
    postgresql \
    postgresql-contrib \
    dos2unix \
    netcat \
    git \
    curl \
    lsof

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Verify installations
python3 --version
psql --version
dos2unix --version
```

## Pre-Deployment Checklist

Before giving to students, ensure:

- [ ] All shell scripts have DOS line endings (already set in repo)
- [ ] File permissions are incorrect (already set: 644 for start_app.sh)
- [ ] PostgreSQL is installed and running
- [ ] Python 3.8+ is available
- [ ] dos2unix tool is available
- [ ] Students have sudo access (needed for PostgreSQL setup)

## Giving Instructions to Students

### Minimal Instructions (Harder)
"The banking system is down. Fix it. Start with SCENARIO.md"

### Standard Instructions (Recommended)
"Read SCENARIO.md for the full mission. Use Unix command-line tools to troubleshoot and fix all issues. The diagnose.sh script can help identify problems."

### With Hints (Easier)
"Read SCENARIO.md and UNIX_EXERCISES.md. The exercises document contains examples of Unix commands you'll need."

## File Structure Overview

```
banking-simulation/
├── README.md                    # Overview for students
├── SCENARIO.md                  # Mission briefing ⭐ START HERE
├── INSTRUCTOR_GUIDE.md          # Solutions (hide from students)
├── UNIX_EXERCISES.md            # Unix command examples
├── app.py                       # Banking application (working)
├── start_app.sh                 # Startup script (HAS BUGS)
├── test_api.sh                  # API testing script
├── diagnose.sh                  # Diagnostic helper tool ⭐ USEFUL
├── requirements.txt             # Python dependencies
│
├── config/                      # Configuration files (HAS BUGS)
│   ├── app.conf
│   └── database.env
│
├── database/                    # Database scripts (HAS BUGS)
│   ├── init_db.sql
│   └── setup_db.sh
│
├── docs/                        # Documentation
│   ├── API_DOCUMENTATION.md
│   └── DEPLOYMENT_NOTES.md      # ⭐ Contains clues
│
├── logs/                        # Log files (⭐ CHECK THESE)
│   ├── app.log
│   └── system.log
│
├── monitoring/                  # Monitoring scripts (HAS BUGS)
│   └── health_check.sh
│
└── tools/                       # Utility scripts (optional challenges)
    ├── backup_restore.sh
    ├── parse_logs.sh
    ├── process_manager.sh
    └── validate_config.sh
```

## Testing the Simulation

Before giving to students, test that all bugs are present:

```bash
cd banking-simulation

# This should fail with permission denied
./start_app.sh

# After fixing permissions, should fail with line ending issues
chmod +x start_app.sh
./start_app.sh

# Continue through all issues...
```

## Expected Issues Students Will Find

1. ❌ Permission denied (chmod needed)
2. ❌ Bad interpreter (dos2unix needed)
3. ❌ Python not found (sed to fix command)
4. ❌ Database password wrong (sed to add !)
5. ❌ SQL syntax errors (sed to fix)
6. ❌ File path wrong (sed to fix)
7. ❌ Variable name wrong (sed to fix)
8. ❌ Port number wrong (sed to fix)

## Grading Rubric

### Basic (60-70%)
- Fixed file permissions
- Converted line endings
- Fixed Python command
- Fixed database password
- Got application running

### Good (70-85%)
- All basic requirements
- Fixed SQL syntax errors
- Fixed all script bugs
- Used appropriate Unix commands
- Documented what was done

### Excellent (85-100%)
- All good requirements
- Used advanced Unix tools (grep/sed/awk)
- Completed optional tool scripts
- Created automated fix script
- Comprehensive documentation
- Demonstrated systematic debugging

## Time Allocation

- **30 minutes**: Minimum expected time (experienced)
- **45 minutes**: Average expected time
- **60 minutes**: Maximum recommended time
- **75+ minutes**: Student may need help

## Common Issues Students Face

1. **Don't know about dos2unix**: Hint about line endings
2. **Unfamiliar with sed**: Point to UNIX_EXERCISES.md
3. **Can't find bugs**: Tell them to check logs carefully
4. **Try to edit Python code**: Emphasize no code changes needed
5. **Skip database setup**: Remind them to initialize DB

## Support Strategy

### Level 1 (15 min): General hints
- "Check the diagnostic script"
- "Read the logs carefully"
- "Look at recent deployment notes"

### Level 2 (30 min): Tool hints
- "You need chmod for permissions"
- "dos2unix can help with line endings"
- "Use sed to fix configuration files"

### Level 3 (45 min): Specific hints
- "Check start_app.sh permissions"
- "The database password is in deployment notes"
- "SQL file has syntax errors on lines 10 and 22"

## Extending the Challenge

For advanced students:

1. **Add monitoring**: Set up cron job for health checks
2. **Log rotation**: Implement log rotation script
3. **Automated testing**: Create comprehensive test suite
4. **Security hardening**: Fix security issues (SSL, debug mode)
5. **Documentation**: Write complete runbook
6. **Automation**: Create one-command deployment script

## Answers Location

**IMPORTANT**: Keep `INSTRUCTOR_GUIDE.md` separate or remove it before giving to students. It contains all solutions.

Consider renaming it to `SOLUTIONS.md` and storing it separately, or password-protecting it.

## Quick Start for Students (Sample Email)

```
Subject: Unix Administration Challenge - Banking System Down

Hi Students,

Your assignment is to fix a broken banking system using Unix command-line tools.

1. Log into your VM
2. Navigate to ~/banking-simulation
3. Read SCENARIO.md for your mission
4. Use Unix tools (grep, sed, awk, chmod, etc.) to fix all issues
5. Get the application running successfully
6. Document your solution

Time limit: 60 minutes
Skills: bash, grep, sed, awk, file permissions, process management

Hints:
- Start with ./diagnose.sh
- Check logs/ directory
- Read docs/DEPLOYMENT_NOTES.md
- UNIX_EXERCISES.md has command examples

Good luck!
```

## Deployment Checklist

Before class:
- [ ] Clone repo to each student VM
- [ ] Verify PostgreSQL is running
- [ ] Verify Python 3 is installed
- [ ] Verify dos2unix is installed
- [ ] Remove or hide INSTRUCTOR_GUIDE.md
- [ ] Test that start_app.sh has permission issues
- [ ] Ensure file has DOS line endings

During class:
- [ ] Give scenario briefing
- [ ] Explain Unix tools available
- [ ] Set time limit (30-60 min)
- [ ] Provide progressive hints as needed

After completion:
- [ ] Review solutions
- [ ] Discuss Unix best practices
- [ ] Share INSTRUCTOR_GUIDE.md
- [ ] Discuss real-world applications
