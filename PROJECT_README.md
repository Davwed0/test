# 🏦 MegaBank Unix/Linux Administration Challenge

## 📖 Overview

This is a **hands-on Unix/Linux administration simulation** designed for teaching students practical command-line skills. Students must troubleshoot and fix a broken banking system using bash scripting, text processing tools (grep/sed/awk), file permissions, and other Unix fundamentals.

**Perfect for**: Unix/Linux courses, system administration training, DevOps bootcamps

## 🎯 Learning Objectives

Students will practice:
- ✅ Bash scripting and debugging
- ✅ Text processing (grep, sed, awk)
- ✅ File permissions (chmod)
- ✅ Line ending issues (DOS vs Unix)
- ✅ Environment variable management
- ✅ Process management (ps, kill, lsof)
- ✅ System troubleshooting
- ✅ Log analysis
- ✅ Systematic debugging approach

## 🚀 Quick Start for Instructors

### 1. Clone to Student VMs

```bash
git clone https://github.com/Davwed0/test.git banking-simulation
cd banking-simulation
```

### 2. Ensure VM Prerequisites

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y python3 python3-pip postgresql dos2unix netcat curl
sudo systemctl start postgresql
```

### 3. Give to Students

Point students to `SCENARIO.md` and let them troubleshoot!

## 📁 What's Inside

### Student-Facing Files
- **SCENARIO.md** - The mission briefing (start here!)
- **README.md** - Basic overview
- **UNIX_EXERCISES.md** - Unix command examples and hints
- **diagnose.sh** - Diagnostic tool to help identify issues

### Application Files (with bugs!)
- **start_app.sh** - Startup script (contains multiple bugs)
- **app.py** - Banking API (this one is correct!)
- **config/** - Configuration files (password wrong)
- **database/** - Database scripts (SQL syntax errors)
- **monitoring/** - Health check scripts (variable name wrong)
- **logs/** - Sample logs showing errors
- **docs/** - API documentation and deployment notes

### Instructor Files
- **INSTRUCTOR_GUIDE.md** - Complete solutions and teaching notes
- **VM_SETUP.md** - Detailed deployment instructions
- **FIX_ALL.sh** - Auto-fix script (for testing)

### Optional Challenges
- **tools/** - Additional utility scripts with bugs for advanced students

## 🐛 Intentional Bugs (Spoiler Alert!)

The simulation includes 8 main issues:

1. **File permissions** - Scripts not executable
2. **DOS line endings** - CRLF instead of LF
3. **Wrong Python command** - Uses `python` instead of `python3`
4. **Database password** - Missing exclamation mark
5. **SQL syntax** - Missing semicolon and parenthesis
6. **Wrong file path** - Incorrect relative path
7. **Variable name** - Typo in variable name
8. **Port number** - Wrong port in check

All require Unix command-line tools to fix!

## ⏱️ Time Estimates

- **Beginner**: 45-60 minutes
- **Intermediate**: 30-45 minutes
- **Advanced**: 20-30 minutes

## 📚 Documentation Structure

```
📄 For Students:
   ├── SCENARIO.md          - Read first!
   ├── README.md            - Overview
   ├── UNIX_EXERCISES.md    - Command examples
   └── diagnose.sh          - Diagnostic helper

📄 For Instructors:
   ├── INSTRUCTOR_GUIDE.md  - All solutions
   ├── VM_SETUP.md          - Deployment guide
   └── FIX_ALL.sh          - Auto-fix for testing

📁 Application:
   ├── app.py               - Banking API
   ├── start_app.sh         - Startup (buggy)
   ├── config/              - Config files (buggy)
   ├── database/            - DB scripts (buggy)
   ├── monitoring/          - Health checks (buggy)
   ├── tools/               - Utilities (optional)
   └── logs/                - Sample logs
```

## 🎓 Usage in Classroom

### Setup (5 minutes)
1. Deploy to student VMs
2. Brief students on the scenario
3. Set time limit (30-60 minutes)

### During (30-60 minutes)
- Students work independently
- Provide progressive hints if stuck
- Monitor progress

### Debrief (15-20 minutes)
- Review solutions
- Discuss Unix best practices
- Share tips and tricks

## ✅ Success Criteria

Students succeed when:
- Application starts without errors
- Database connects successfully
- Health endpoint responds: `curl http://localhost:8080/health`
- All API tests pass: `./test_api.sh`
- They document their solution process

## 🔧 Unix Commands Students Will Use

```bash
# File operations
chmod +x script.sh              # Fix permissions
dos2unix script.sh              # Fix line endings
file script.sh                  # Check file type

# Text processing
grep "pattern" file             # Search
sed 's/old/new/g' file          # Replace
awk '{print $1}' file           # Extract columns

# Debugging
tail -f logs/app.log            # Follow logs
ps aux | grep python            # Find processes
lsof -i :8080                   # Check ports

# Environment
source config/database.env      # Load variables
echo $DB_PASSWORD               # Check variables
```

## 🎯 Grading Rubric

### Basic (60-70%)
- Fixed permissions and line endings
- Got application running
- Basic documentation

### Good (70-85%)
- Fixed all main issues
- Used appropriate Unix commands
- Systematic approach
- Good documentation

### Excellent (85-100%)
- Fixed all issues including optional ones
- Advanced use of grep/sed/awk
- Created automation scripts
- Comprehensive documentation

## 🔒 Security Note

This is a **training simulation** with intentionally broken code. The "bugs" are:
- Configuration errors (not security vulnerabilities)
- Script syntax issues
- File format problems

**Do not use this code in production!**

## 📦 What to Give Students

### Minimal (Harder)
- Just the repository
- "Fix the broken banking system"

### Standard (Recommended)
- Repository + SCENARIO.md
- "Use Unix tools to troubleshoot"

### With Guidance (Easier)
- Repository + SCENARIO.md + UNIX_EXERCISES.md
- "Examples of commands you'll need are provided"

## 🤝 Contributing

This is a training simulation. Feel free to:
- Add more Unix challenges
- Create variations
- Improve documentation
- Share with students

## 📧 Support

For questions about using this simulation:
- Check INSTRUCTOR_GUIDE.md
- Review VM_SETUP.md
- See UNIX_EXERCISES.md for command examples

## 📝 License

Free to use for educational purposes.

---

## 🚀 Quick Start Commands

```bash
# For instructors: Test the simulation
git clone https://github.com/Davwed0/test.git banking-simulation
cd banking-simulation
./diagnose.sh                    # See what's broken
./FIX_ALL.sh                     # Auto-fix all issues (testing only)

# For students: Start troubleshooting
cd banking-simulation
cat SCENARIO.md                  # Read your mission
./diagnose.sh                    # Check system status
./start_app.sh                   # Try to start (will fail)
# ... now debug and fix using Unix commands!
```

## 🎬 Expected Student Journey

1. Read SCENARIO.md - "Oh no, the banking system is down!"
2. Try `./start_app.sh` - "Permission denied"
3. Run `./diagnose.sh` - "Scripts aren't executable"
4. Fix with `chmod +x start_app.sh`
5. Try again - "Bad interpreter error"
6. Check with `file start_app.sh` - "Has CRLF line endings"
7. Fix with `dos2unix start_app.sh`
8. Try again - "Python not found"
9. Use `grep` to find issue, `sed` to fix
10. Continue debugging until success!

---

**Made with ❤️ for Unix/Linux education**
