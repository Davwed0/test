# Grep & Find Mastery Playground

An interactive bash script that creates a comprehensive Linux learning environment for mastering `grep`, `find`, `git log` analysis, and network enumeration through progressively challenging quests.

## 🎯 Overview

This repository contains a single, self-contained bash script that sets up a realistic training playground for Linux command-line skills. When executed, it:

1. Creates a temporary learning environment at `~/grep-lab-playground`
2. Downloads a real Linux kernel git repository for authentic git log analysis
3. Generates realistic sample data (syslog files, network scans, user activity logs)
4. Creates 5 progressive difficulty levels with 25 hands-on challenges
5. Provides complete solutions for self-validation

## 🚀 Quick Start

### Prerequisites
- Linux/Unix environment (Linux, macOS, WSL)
- Git installed
- Internet connection (for kernel repo download)
- ~500MB free disk space

### Installation & Usage

```bash
# Clone this repository
git clone https://github.com/Davwed0/test.git
cd test

# Run the setup script
./grep-find-playground.sh
```

The script will:
- Create the playground directory
- Download the Linux kernel repository (~300MB, takes 10-20 minutes)
- Generate all sample data and challenges
- Set up solution scripts

Once complete:
```bash
cd ~/grep-lab-playground
cat README.md  # Read the playground guide
cat LEVEL_1_BEGINNER.md  # Start with Level 1
```

## 📚 What You'll Learn

### Skills Covered
- **grep**: Pattern matching, regular expressions, context searches, case-insensitive searches
- **find**: File discovery, permission-based searches, time-based queries
- **git log**: Repository analysis, author filtering, commit statistics, merge detection
- **awk/sed**: Advanced text processing and data manipulation
- **Command Chaining**: Building powerful pipelines with multiple commands

### Challenge Levels

#### Level 1: Beginner (30 min)
- Basic pattern matching with grep
- Simple find operations
- File discovery
- 5 foundational challenges

#### Level 2: Intermediate (45 min)
- Advanced regex patterns
- Extended grep options
- Permission-based searches
- 5 intermediate challenges

#### Level 3: Advanced (1 hour)
- Complex queries and pipelines
- Git log analysis
- Multi-line context searches
- 5 advanced challenges

#### Level 4: Expert (1.5 hours)
- Network data analysis
- Advanced git repository analysis
- Complex command pipelines
- 5 expert challenges

#### Level 5: Master (2 hours)
- Security auditing
- Data aggregation and analysis
- Comprehensive problem-solving
- 5 master-level challenges

## 📁 Generated Playground Structure

```
~/grep-lab-playground/
├── README.md                  # Playground guide
├── LEVEL_1_BEGINNER.md       # Level 1 challenges
├── LEVEL_2_INTERMEDIATE.md   # Level 2 challenges
├── LEVEL_3_ADVANCED.md       # Level 3 challenges
├── LEVEL_4_EXPERT.md         # Level 4 challenges
├── LEVEL_5_MASTER.md         # Level 5 challenges
├── data/                      # Realistic sample data
│   ├── logs/                 # Syslog and application logs
│   ├── network/              # Network scan results, IP ranges
│   ├── users/                # User activity and login history
│   ├── config/               # Configuration files
│   └── hidden/               # Hidden files for find practice
├── linux-kernel/             # Real Linux kernel git repository
└── solutions/                # Solution scripts
    ├── level1_solutions.sh
    ├── level2_solutions.sh
    ├── level3_solutions.sh
    ├── level4_solutions.sh
    └── level5_solutions.sh
```

## 🔍 Sample Data

The playground includes:

### Log Files
- `syslog.csv`: 20+ realistic system log entries (SSH, MySQL, Apache, etc.)
- `application.log`: Application-level logging with various severity levels

### Network Data
- `nmap_scan.txt`: Realistic nmap scan results with 7 hosts
- `ip_ranges.txt`: Network topology with /24, /16 CIDR ranges
- `firewall_rules.txt`: Example firewall configuration

### User Data
- `login_history.csv`: User login attempts, session durations, IP addresses
- `users.txt`: Unix-style user database

### Configuration Files
- nginx.conf, database.conf, and more
- Hidden config files for practice finding secrets
- Files with various permissions (SUID, restricted, world-readable)

## 🎓 Educational Use Cases

Perfect for:
- **DevOps Training**: Learn essential command-line skills
- **Security Training**: Practice log analysis and security auditing
- **Linux Certification Prep**: Hands-on practice for LPIC, CompTIA Linux+
- **Self-Study**: Progressive challenges with complete solutions
- **Classroom Use**: Ready-to-use curriculum with 5+ hours of content

## 🛠️ Technical Details

### Linux Kernel Repository
- Uses shallow clone (depth=1000) for efficiency
- Fetches additional history (depth=5000) for comprehensive analysis
- Source: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
- Fallback mirror: https://github.com/torvalds/linux.git

### Script Features
- Color-coded output for better readability
- Automatic cleanup of existing playgrounds
- Error handling and validation
- Progress indicators during setup
- Self-contained (all data generated by the script)

## 📖 Example Challenges

### Beginner
```bash
# Find all ERROR entries in logs
grep "ERROR" data/logs/syslog.csv

# Find all .txt files
find data/ -name "*.txt"
```

### Advanced
```bash
# Find failed SSH attempts from external IPs
grep "Failed password" data/logs/syslog.csv | grep -v "192.168"

# Find commits by Linus Torvalds
cd linux-kernel && git log --author="Linus" --oneline | head -20
```

### Master
```bash
# User with longest total session time
awk -F',' 'NR>1 {user[$1]+=$5} END {for (u in user) print user[u], u}' \
  data/users/login_history.csv | sort -rn | head -1
```

## 🤝 Contributing

This is an educational project. Feel free to:
- Report issues or bugs
- Suggest additional challenges
- Improve documentation
- Add more realistic sample data

## 📄 License

This project is provided as-is for educational purposes.

## 🎉 Acknowledgments

- Uses the real Linux kernel repository for authentic learning
- Inspired by real-world DevOps and security scenarios
- Designed for progressive skill development

---

**Ready to become a command-line master?** Run `./grep-find-playground.sh` and start your journey! 🚀