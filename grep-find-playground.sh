#!/usr/bin/env bash

################################################################################
# Grep & Find Mastery Playground
# An interactive learning environment for mastering Linux text processing,
# file searching, git log analysis, and network enumeration skills.
################################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PLAYGROUND_DIR="$HOME/grep-lab-playground"
SOLUTIONS_DIR="$PLAYGROUND_DIR/solutions"
DATA_DIR="$PLAYGROUND_DIR/data"
KERNEL_DIR="$PLAYGROUND_DIR/linux-kernel"

################################################################################
# Helper Functions
################################################################################

print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║         GREP & FIND MASTERY PLAYGROUND                       ║
║         Interactive Linux Skills Training Environment         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

################################################################################
# Setup Functions
################################################################################

cleanup_old_playground() {
    if [ -d "$PLAYGROUND_DIR" ]; then
        log_warning "Found existing playground at $PLAYGROUND_DIR"
        read -p "Do you want to remove it and start fresh? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing old playground..."
            rm -rf "$PLAYGROUND_DIR"
            log_success "Old playground removed"
        else
            log_error "Cannot proceed with existing playground. Exiting."
            exit 1
        fi
    fi
}

create_directory_structure() {
    log_info "Creating playground directory structure..."
    mkdir -p "$PLAYGROUND_DIR"
    mkdir -p "$SOLUTIONS_DIR"
    mkdir -p "$DATA_DIR"/{logs,network,users,config,hidden}
    
    # Create hidden files for find practice
    touch "$DATA_DIR/hidden/.secret_config"
    touch "$DATA_DIR/hidden/.backup_file"
    mkdir -p "$DATA_DIR/hidden/.cache"
    touch "$DATA_DIR/hidden/.cache/temp.log"
    
    log_success "Directory structure created"
}

download_linux_kernel() {
    log_info "Downloading Linux kernel repository (this may take 10-15 minutes)..."
    log_info "Using shallow clone to save time and space..."
    
    # Use shallow clone with limited history
    if ! git clone --depth=1000 --single-branch --branch master \
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git \
        "$KERNEL_DIR" 2>&1 | tee /tmp/git_clone.log; then
        log_error "Failed to clone kernel repository"
        log_info "Trying alternative mirror..."
        git clone --depth=1000 --single-branch \
            https://github.com/torvalds/linux.git \
            "$KERNEL_DIR"
    fi
    
    cd "$KERNEL_DIR"
    # Fetch more history for better log analysis
    git fetch --depth=5000 2>/dev/null || true
    
    log_success "Linux kernel repository downloaded ($(du -sh "$KERNEL_DIR" | cut -f1))"
}

generate_sample_data() {
    log_info "Generating realistic sample data..."
    
    # Generate syslog data
    generate_syslog_data
    
    # Generate network scan data
    generate_network_data
    
    # Generate user activity logs
    generate_user_activity
    
    # Generate configuration files
    generate_config_files
    
    # Generate files with various permissions
    generate_permission_examples
    
    log_success "Sample data generated"
}

generate_syslog_data() {
    cat > "$DATA_DIR/logs/syslog.csv" << 'EOF'
timestamp,level,service,message,ip_address
2024-01-15 08:23:45,INFO,sshd,Accepted publickey for admin,192.168.1.100
2024-01-15 08:24:12,ERROR,apache2,Connection refused from,203.0.113.45
2024-01-15 08:25:33,WARNING,mysql,Slow query detected,192.168.1.50
2024-01-15 08:26:01,INFO,cron,Job completed successfully,127.0.0.1
2024-01-15 08:27:19,ERROR,sshd,Failed password for root,198.51.100.23
2024-01-15 08:28:42,INFO,nginx,GET /api/users HTTP/1.1,192.168.1.150
2024-01-15 08:29:55,CRITICAL,kernel,Out of memory condition,127.0.0.1
2024-01-15 08:30:18,INFO,sshd,Accepted password for ubuntu,10.0.0.5
2024-01-15 08:31:29,WARNING,firewall,Suspicious traffic detected,203.0.113.67
2024-01-15 08:32:44,ERROR,docker,Container exited with code 137,172.17.0.2
2024-01-15 08:33:11,INFO,systemd,Service nginx.service started,127.0.0.1
2024-01-15 08:34:28,ERROR,sshd,Failed password for admin,198.51.100.89
2024-01-15 08:35:50,WARNING,apache2,Timeout connecting to backend,192.168.1.200
2024-01-15 08:36:15,INFO,postfix,Email sent successfully,192.168.1.100
2024-01-15 08:37:33,CRITICAL,sshd,Too many authentication failures,203.0.113.123
2024-01-15 08:38:47,INFO,ufw,Allowed connection from,192.168.1.75
2024-01-15 08:39:22,ERROR,mysql,Access denied for user 'test',10.0.0.15
2024-01-15 08:40:05,WARNING,disk,Disk usage above 80%,127.0.0.1
2024-01-15 08:41:18,INFO,sshd,Connection closed by,192.168.1.100
2024-01-15 08:42:39,ERROR,cron,Job failed with exit code 1,127.0.0.1
EOF

    cat > "$DATA_DIR/logs/application.log" << 'EOF'
[2024-01-15 10:00:00] INFO: Application started
[2024-01-15 10:00:05] DEBUG: Database connection established
[2024-01-15 10:00:10] INFO: User 'john.doe' logged in from 192.168.1.50
[2024-01-15 10:01:23] WARNING: API rate limit approaching for user 'jane.smith'
[2024-01-15 10:02:45] ERROR: Failed to process payment for order #12345
[2024-01-15 10:03:12] INFO: Cache cleared successfully
[2024-01-15 10:04:33] CRITICAL: Unable to connect to payment gateway
[2024-01-15 10:05:01] INFO: User 'admin' performed backup operation
[2024-01-15 10:06:28] DEBUG: Query executed in 234ms
[2024-01-15 10:07:45] WARNING: Memory usage at 75%
[2024-01-15 10:08:19] ERROR: Invalid API key from 203.0.113.99
[2024-01-15 10:09:34] INFO: Scheduled job 'cleanup' started
[2024-01-15 10:10:52] INFO: Processing batch of 1000 records
[2024-01-15 10:11:18] ERROR: Timeout while connecting to external API
[2024-01-15 10:12:41] WARNING: Deprecated function call detected
EOF
}

generate_network_data() {
    cat > "$DATA_DIR/network/nmap_scan.txt" << 'EOF'
Nmap scan report for 192.168.1.0/24

Host: 192.168.1.1 (router.local)
Ports: 22/open/tcp//ssh//OpenSSH 8.2
       80/open/tcp//http//nginx 1.18.0
       443/open/tcp//https//nginx 1.18.0

Host: 192.168.1.10 (webserver.local)
Ports: 22/open/tcp//ssh//OpenSSH 8.2
       80/open/tcp//http//Apache 2.4.41
       443/open/tcp//https//Apache 2.4.41
       3306/open/tcp//mysql//MySQL 8.0.23

Host: 192.168.1.50 (database.local)
Ports: 22/open/tcp//ssh//OpenSSH 8.2
       3306/open/tcp//mysql//MySQL 8.0.23
       5432/open/tcp//postgresql//PostgreSQL 13.2

Host: 192.168.1.100 (admin-laptop.local)
Ports: 22/open/tcp//ssh//OpenSSH 8.4

Host: 192.168.1.150 (api-server.local)
Ports: 22/open/tcp//ssh//OpenSSH 8.2
       80/open/tcp//http//nginx 1.18.0
       443/open/tcp//https//nginx 1.18.0
       8080/open/tcp//http//Node.js Express

Host: 203.0.113.45 (external-scanner)
Ports: 80/filtered/tcp//http//
       443/filtered/tcp//https//
       8080/filtered/tcp//http//

Host: 198.51.100.23 (suspicious-host)
Ports: 22/open/tcp//ssh//OpenSSH 7.4
       23/open/tcp//telnet//
       21/open/tcp//ftp//vsftpd 3.0.3
EOF

    cat > "$DATA_DIR/network/ip_ranges.txt" << 'EOF'
# Internal Networks
192.168.1.0/24    # Main office network
192.168.2.0/24    # Guest network
10.0.0.0/16       # Data center network
172.16.0.0/12     # Container network

# DMZ Networks
203.0.113.0/24    # Public DMZ
198.51.100.0/24   # External services

# Subnets
192.168.1.0/26    # Management subnet (1-62)
192.168.1.64/26   # User subnet (65-126)
192.168.1.128/26  # Server subnet (129-190)
192.168.1.192/26  # IoT devices (193-254)

# Special ranges
127.0.0.0/8       # Loopback
169.254.0.0/16    # Link-local
EOF

    cat > "$DATA_DIR/network/firewall_rules.txt" << 'EOF'
ACCEPT    tcp 192.168.1.0/24  22    SSH from internal network
ACCEPT    tcp 192.168.1.0/24  80    HTTP from internal network
ACCEPT    tcp 192.168.1.0/24  443   HTTPS from internal network
DENY      tcp 0.0.0.0/0       23    Block Telnet from anywhere
DENY      tcp 0.0.0.0/0       21    Block FTP from anywhere
ACCEPT    tcp 203.0.113.0/24  443   HTTPS from DMZ
DENY      tcp 198.51.100.0/24 *     Block suspicious subnet
ACCEPT    tcp 10.0.0.0/16     3306  MySQL from data center
ACCEPT    tcp 10.0.0.0/16     5432  PostgreSQL from data center
LOG       tcp *               22    Log all SSH attempts
EOF
}

generate_user_activity() {
    cat > "$DATA_DIR/users/login_history.csv" << 'EOF'
username,timestamp,ip_address,status,session_duration
john.doe,2024-01-15 08:00:00,192.168.1.100,success,3600
jane.smith,2024-01-15 08:15:00,192.168.1.101,success,7200
admin,2024-01-15 08:30:00,192.168.1.1,success,1800
root,2024-01-15 08:45:00,203.0.113.45,failed,0
john.doe,2024-01-15 09:00:00,192.168.1.100,success,5400
test.user,2024-01-15 09:15:00,198.51.100.23,failed,0
admin,2024-01-15 09:30:00,10.0.0.5,success,3600
root,2024-01-15 09:45:00,203.0.113.67,failed,0
jane.smith,2024-01-15 10:00:00,192.168.1.101,success,4500
developer,2024-01-15 10:15:00,192.168.1.150,success,9000
admin,2024-01-15 10:30:00,192.168.1.1,success,2700
root,2024-01-15 10:45:00,198.51.100.89,failed,0
backup,2024-01-15 11:00:00,10.0.0.10,success,600
john.doe,2024-01-15 11:15:00,192.168.1.100,logout,0
EOF

    cat > "$DATA_DIR/users/users.txt" << 'EOF'
john.doe:1001:developers:John Doe:/home/john.doe:/bin/bash
jane.smith:1002:developers:Jane Smith:/home/jane.smith:/bin/bash
admin:1000:administrators:System Admin:/home/admin:/bin/bash
developer:1003:developers:Dev User:/home/developer:/bin/bash
backup:1004:services:Backup Service:/var/backups:/bin/false
root:0:root:Root User:/root:/bin/bash
test.user:1005:testers:Test User:/home/test.user:/bin/bash
monitor:1006:services:Monitoring Service:/var/monitor:/bin/false
EOF
}

generate_config_files() {
    cat > "$DATA_DIR/config/nginx.conf" << 'EOF'
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location /api {
        proxy_pass http://192.168.1.150:8080;
        proxy_set_header Host $host;
    }
}

server {
    listen 443 ssl;
    server_name secure.example.com;
    
    ssl_certificate /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/private/server.key;
    
    location / {
        proxy_pass http://10.0.0.100:3000;
    }
}
EOF

    cat > "$DATA_DIR/config/database.conf" << 'EOF'
[mysqld]
port = 3306
bind-address = 192.168.1.50
max_connections = 100
innodb_buffer_pool_size = 1G

[postgresql]
port = 5432
listen_addresses = '10.0.0.0/16'
max_connections = 200
shared_buffers = 256MB
EOF

    cat > "$DATA_DIR/hidden/.secret_config" << 'EOF'
API_KEY=example_api_key_12345_REPLACE_WITH_REAL_KEY
DATABASE_PASSWORD=super_secret_password_123
JWT_SECRET=your-256-bit-secret-replace-me
ENCRYPTION_KEY=AES256_ENCRYPTION_KEY_HERE_REPLACE_ME
EOF
}

generate_permission_examples() {
    # Create files with different permissions
    touch "$DATA_DIR/config/world_readable.txt"
    chmod 644 "$DATA_DIR/config/world_readable.txt"
    
    touch "$DATA_DIR/config/owner_only.txt"
    chmod 600 "$DATA_DIR/config/owner_only.txt"
    
    touch "$DATA_DIR/config/executable.sh"
    chmod 755 "$DATA_DIR/config/executable.sh"
    
    mkdir -p "$DATA_DIR/restricted"
    chmod 700 "$DATA_DIR/restricted"
    
    touch "$DATA_DIR/restricted/sensitive_data.txt"
    chmod 400 "$DATA_DIR/restricted/sensitive_data.txt"
    
    # Create SUID example (for learning purposes)
    touch "$DATA_DIR/config/suid_example"
    chmod 4755 "$DATA_DIR/config/suid_example"
    
    # Files modified at different times
    touch -t 202401010000 "$DATA_DIR/config/old_file.txt"
    touch -t 202401150000 "$DATA_DIR/config/recent_file.txt"
    touch "$DATA_DIR/config/new_file.txt"
}

################################################################################
# Challenge Generation
################################################################################

generate_challenges() {
    log_info "Generating challenge levels and solutions..."
    
    generate_level1_beginner
    generate_level2_intermediate
    generate_level3_advanced
    generate_level4_expert
    generate_level5_master
    
    generate_master_readme
    
    log_success "All challenges and solutions generated"
}

generate_level1_beginner() {
    cat > "$PLAYGROUND_DIR/LEVEL_1_BEGINNER.md" << 'EOF'
# Level 1: Beginner - Basic Pattern Matching

Welcome to the Grep & Find Playground! Start with these foundational exercises.

## Challenge 1.1: Find All ERROR Entries
**Objective**: Find all ERROR level entries in the syslog

**Hint**: Use grep to search for the word "ERROR" in `data/logs/syslog.csv`

**Your Command Here**:
```bash
# Try: grep "ERROR" data/logs/syslog.csv
```

**Expected Output**: Should show 6 ERROR entries

---

## Challenge 1.2: Count CRITICAL Events
**Objective**: Count how many CRITICAL level events occurred

**Hint**: Use grep with the -c flag to count matches

**Your Command Here**:
```bash
# Try: grep -c "CRITICAL" data/logs/syslog.csv
```

**Expected Output**: 2

---

## Challenge 1.3: Find SSH Login Attempts
**Objective**: Find all SSH-related log entries

**Hint**: Search for "sshd" in the syslog file

**Your Command Here**:
```bash
# Try: grep "sshd" data/logs/syslog.csv
```

**Expected Output**: Should show 8 sshd entries

---

## Challenge 1.4: Find Files Modified Today
**Objective**: Use find to locate all .txt files in the data directory

**Hint**: Use: find data/ -name "*.txt"

**Your Command Here**:
```bash
# Try: find data/ -name "*.txt"
```

**Expected Output**: Multiple .txt files

---

## Challenge 1.5: Find Hidden Files
**Objective**: Discover all hidden files (starting with .)

**Hint**: Use: find data/ -name ".*"

**Your Command Here**:
```bash
# Try: find data/ -name ".*" -type f
```

**Expected Output**: .secret_config, .backup_file, etc.

EOF

    # Generate solutions
    cat > "$SOLUTIONS_DIR/level1_solutions.sh" << 'EOF'
#!/bin/bash
# Level 1 Solutions

echo "=== Challenge 1.1: Find All ERROR Entries ==="
grep "ERROR" data/logs/syslog.csv
echo ""

echo "=== Challenge 1.2: Count CRITICAL Events ==="
grep -c "CRITICAL" data/logs/syslog.csv
echo ""

echo "=== Challenge 1.3: Find SSH Login Attempts ==="
grep "sshd" data/logs/syslog.csv
echo ""

echo "=== Challenge 1.4: Find .txt Files ==="
find data/ -name "*.txt"
echo ""

echo "=== Challenge 1.5: Find Hidden Files ==="
find data/ -name ".*" -type f
echo ""
EOF
    chmod +x "$SOLUTIONS_DIR/level1_solutions.sh"
}

generate_level2_intermediate() {
    cat > "$PLAYGROUND_DIR/LEVEL_2_INTERMEDIATE.md" << 'EOF'
# Level 2: Intermediate - Advanced Patterns & Regex

Build on your skills with regular expressions and advanced grep options.

## Challenge 2.1: Find Failed SSH Attempts from External IPs
**Objective**: Find failed SSH login attempts from IPs outside 192.168.x.x range

**Hint**: Use grep with patterns for "Failed password" and IPs NOT starting with 192.168

**Your Command Here**:
```bash
# Try: grep "Failed password" data/logs/syslog.csv | grep -v "192.168"
```

**Expected Output**: 2 entries (198.51.100.23 and 198.51.100.89)

---

## Challenge 2.2: Extract Only IP Addresses
**Objective**: Extract just the IP addresses from syslog.csv

**Hint**: Use grep with -oE for extended regex: [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}

**Your Command Here**:
```bash
# Try: grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' data/logs/syslog.csv
```

**Expected Output**: List of all IP addresses

---

## Challenge 2.3: Find MySQL Related Issues
**Objective**: Find all WARNING or ERROR entries related to mysql service

**Hint**: Use grep with extended regex (-E) to search for "mysql.*(WARNING|ERROR)"

**Your Command Here**:
```bash
# Try: grep -E "mysql.*(WARNING|ERROR)" data/logs/syslog.csv
```

**Expected Output**: 2 entries

---

## Challenge 2.4: Case-Insensitive Search
**Objective**: Find all lines containing "error" or "ERROR" (case insensitive)

**Hint**: Use grep -i flag

**Your Command Here**:
```bash
# Try: grep -i "error" data/logs/syslog.csv
```

**Expected Output**: All ERROR entries regardless of case

---

## Challenge 2.5: Find Files by Permission
**Objective**: Find all files with execute permission (chmod 755 or similar)

**Hint**: Use: find data/ -type f -perm -100

**Your Command Here**:
```bash
# Try: find data/config -type f -perm -100
```

**Expected Output**: executable.sh and suid_example

EOF

    cat > "$SOLUTIONS_DIR/level2_solutions.sh" << 'EOF'
#!/bin/bash
# Level 2 Solutions

echo "=== Challenge 2.1: Failed SSH from External IPs ==="
grep "Failed password" data/logs/syslog.csv | grep -v "192.168"
echo ""

echo "=== Challenge 2.2: Extract IP Addresses ==="
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' data/logs/syslog.csv | head -10
echo "(showing first 10)"
echo ""

echo "=== Challenge 2.3: MySQL Issues ==="
grep -E "mysql.*(WARNING|ERROR)" data/logs/syslog.csv
echo ""

echo "=== Challenge 2.4: Case-Insensitive ERROR ==="
grep -i "error" data/logs/syslog.csv | head -5
echo "(showing first 5)"
echo ""

echo "=== Challenge 2.5: Executable Files ==="
find data/config -type f -perm -100
echo ""
EOF
    chmod +x "$SOLUTIONS_DIR/level2_solutions.sh"
}

generate_level3_advanced() {
    cat > "$PLAYGROUND_DIR/LEVEL_3_ADVANCED.md" << 'EOF'
# Level 3: Advanced - Complex Queries & Git Log Analysis

Master complex patterns and dive into git repository analysis.

## Challenge 3.1: Find Suspicious Activity Pattern
**Objective**: Find all failed login attempts followed by finding the unique IPs

**Hint**: Chain grep with sort and uniq

**Your Command Here**:
```bash
# Try: grep "failed" data/users/login_history.csv | cut -d',' -f3 | sort | uniq
```

**Expected Output**: Unique IPs with failed logins

---

## Challenge 3.2: Multi-Line Context Search
**Objective**: Show 2 lines before and after each CRITICAL event

**Hint**: Use grep -A 2 -B 2 for context lines

**Your Command Here**:
```bash
# Try: grep -A 2 -B 2 "CRITICAL" data/logs/syslog.csv
```

**Expected Output**: CRITICAL lines with surrounding context

---

## Challenge 3.3: Find Commits by Linus Torvalds
**Objective**: Search git log for commits authored by Linus Torvalds

**Hint**: Use: git log --author="Linus Torvalds" --oneline

**Your Command Here**:
```bash
# Try: cd linux-kernel && git log --author="Linus" --oneline | head -20
```

**Expected Output**: List of commits by Linus

---

## Challenge 3.4: Find Merge Commits
**Objective**: Find all merge commits in the last 500 commits

**Hint**: Use: git log --merges --oneline -n 500

**Your Command Here**:
```bash
# Try: cd linux-kernel && git log --merges --oneline -n 500 | wc -l
```

**Expected Output**: Count of merge commits

---

## Challenge 3.5: Search Git History for Keyword
**Objective**: Find all commits that mention "security" in the commit message

**Hint**: Use: git log --grep="security" --oneline

**Your Command Here**:
```bash
# Try: cd linux-kernel && git log --grep="security" -i --oneline | head -20
```

**Expected Output**: Commits mentioning security

EOF

    cat > "$SOLUTIONS_DIR/level3_solutions.sh" << 'EOF'
#!/bin/bash
# Level 3 Solutions

echo "=== Challenge 3.1: Suspicious IPs ==="
grep "failed" data/users/login_history.csv | cut -d',' -f3 | sort | uniq
echo ""

echo "=== Challenge 3.2: Context Around CRITICAL ==="
grep -A 2 -B 2 "CRITICAL" data/logs/syslog.csv
echo ""

echo "=== Challenge 3.3: Linus Torvalds Commits ==="
cd linux-kernel
git log --author="Linus" --oneline | head -20
echo ""

echo "=== Challenge 3.4: Merge Commits Count ==="
git log --merges --oneline -n 500 | wc -l
echo ""

echo "=== Challenge 3.5: Security Commits ==="
git log --grep="security" -i --oneline | head -20
cd ..
echo ""
EOF
    chmod +x "$SOLUTIONS_DIR/level3_solutions.sh"
}

generate_level4_expert() {
    cat > "$PLAYGROUND_DIR/LEVEL_4_EXPERT.md" << 'EOF'
# Level 4: Expert - Network Analysis & Complex Pipelines

Analyze network data and create sophisticated command pipelines.

## Challenge 4.1: Find Hosts with MySQL Open
**Objective**: Extract hostnames that have MySQL port (3306) open

**Hint**: Use: grep "3306/open" data/network/nmap_scan.txt | grep "Host:"

**Your Command Here**:
```bash
# Try: grep "3306/open" data/network/nmap_scan.txt -B 3 | grep "Host:" | cut -d'(' -f2 | cut -d')' -f1
```

**Expected Output**: webserver.local, database.local

---

## Challenge 4.2: Count Services per Host
**Objective**: Determine which host has the most open ports

**Hint**: Parse the nmap scan results and count ports per host

**Your Command Here**:
```bash
# Try: grep "Ports:" data/network/nmap_scan.txt | wc -l
```

**Expected Output**: Analysis of ports per host

---

## Challenge 4.3: Find All /24 Networks
**Objective**: Extract all /24 network ranges from ip_ranges.txt

**Hint**: Use grep with pattern matching for "/24"

**Your Command Here**:
```bash
# Try: grep "/24" data/network/ip_ranges.txt | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/24'
```

**Expected Output**: All /24 CIDR ranges

---

## Challenge 4.4: Find Blocked Services in Firewall
**Objective**: List all services that are explicitly DENYed in firewall rules

**Hint**: Use grep to find DENY rules and extract service names/ports

**Your Command Here**:
```bash
# Try: grep "DENY" data/network/firewall_rules.txt
```

**Expected Output**: Telnet (23), FTP (21), and suspicious subnet rules

---

## Challenge 4.5: Git File History Analysis
**Objective**: Find which files changed most frequently in kernel

**Hint**: Use: git log --name-only --pretty=format: | sort | uniq -c | sort -rn

**Your Command Here**:
```bash
# Try: cd linux-kernel && git log --name-only --pretty=format: -n 1000 | grep -v '^$' | sort | uniq -c | sort -rn | head -20
```

**Expected Output**: Most frequently changed files

EOF

    cat > "$SOLUTIONS_DIR/level4_solutions.sh" << 'EOF'
#!/bin/bash
# Level 4 Solutions

echo "=== Challenge 4.1: Hosts with MySQL ==="
grep "3306/open" data/network/nmap_scan.txt -B 3 | grep "Host:" | cut -d'(' -f2 | cut -d')' -f1
echo ""

echo "=== Challenge 4.2: Port Count Analysis ==="
echo "Analyzing ports per host..."
grep -E "^Host:" data/network/nmap_scan.txt -A 10 | head -20
echo ""

echo "=== Challenge 4.3: All /24 Networks ==="
grep "/24" data/network/ip_ranges.txt | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/24'
echo ""

echo "=== Challenge 4.4: Blocked Services ==="
grep "DENY" data/network/firewall_rules.txt
echo ""

echo "=== Challenge 4.5: Most Changed Files ==="
cd linux-kernel
git log --name-only --pretty=format: -n 1000 | grep -v '^$' | sort | uniq -c | sort -rn | head -20
cd ..
echo ""
EOF
    chmod +x "$SOLUTIONS_DIR/level4_solutions.sh"
}

generate_level5_master() {
    cat > "$PLAYGROUND_DIR/LEVEL_5_MASTER.md" << 'EOF'
# Level 5: Master - Ultimate Challenges

Combine everything you've learned for these comprehensive challenges.

## Challenge 5.1: Security Audit Pipeline
**Objective**: Create a complete security audit report

Find:
1. All failed login attempts from external IPs
2. All CRITICAL/ERROR events
3. All hosts with suspicious ports open (telnet, ftp)

**Your Command Here**:
```bash
# Solution involves chaining multiple greps and creating a report
```

**Expected Output**: Comprehensive security report

---

## Challenge 5.2: User Activity Analysis
**Objective**: Find the user with the longest total session time

**Hint**: Sum session_duration per user from login_history.csv

**Your Command Here**:
```bash
# Try: awk -F',' 'NR>1 {user[$1]+=$5} END {for (u in user) print user[u], u}' data/users/login_history.csv | sort -rn | head -1
```

**Expected Output**: User with most session time

---

## Challenge 5.3: Git Commit Frequency Timeline
**Objective**: Show commits per month for the last year

**Hint**: Use: git log --since="1 year ago" --format="%cd" --date=format:"%Y-%m" | sort | uniq -c

**Your Command Here**:
```bash
# Try: cd linux-kernel && git log --since="1 year ago" --format="%cd" --date=format:"%Y-%m" | sort | uniq -c
```

**Expected Output**: Commit count per month

---

## Challenge 5.4: Find SUID/SGID Files
**Objective**: Locate all files with SUID or SGID bits set (security risk!)

**Hint**: Use: find data/ -type f \( -perm -4000 -o -perm -2000 \)

**Your Command Here**:
```bash
# Try: find data/ -type f \( -perm -4000 -o -perm -2000 \)
```

**Expected Output**: suid_example file

---

## Challenge 5.5: Complete Network Topology Map
**Objective**: Create a complete map of all IPs, their hostnames, and open services

Parse nmap_scan.txt to create a structured report showing:
- IP address
- Hostname
- All open ports with service names

**Your Command Here**:
```bash
# Advanced parsing challenge - combine grep, awk, and sed
```

**Expected Output**: Structured network map

EOF

    cat > "$SOLUTIONS_DIR/level5_solutions.sh" << 'EOF'
#!/bin/bash
# Level 5 Solutions

echo "=== Challenge 5.1: Security Audit ==="
echo "Failed External Logins:"
grep "failed" data/users/login_history.csv | grep -v "192.168" | cut -d',' -f1,3
echo ""
echo "Critical/Error Events:"
grep -E "(CRITICAL|ERROR)" data/logs/syslog.csv | wc -l
echo "Total critical/error events found"
echo ""
echo "Suspicious Ports:"
grep -E "(telnet|ftp)" data/network/nmap_scan.txt
echo ""

echo "=== Challenge 5.2: User with Most Session Time ==="
awk -F',' 'NR>1 {user[$1]+=$5} END {for (u in user) print user[u], u}' data/users/login_history.csv | sort -rn | head -1
echo ""

echo "=== Challenge 5.3: Git Commit Timeline ==="
cd linux-kernel
git log --since="1 year ago" --format="%cd" --date=format:"%Y-%m" | sort | uniq -c | head -12
cd ..
echo ""

echo "=== Challenge 5.4: SUID/SGID Files ==="
find data/ -type f \( -perm -4000 -o -perm -2000 \)
echo ""

echo "=== Challenge 5.5: Network Topology ==="
echo "Complete network mapping:"
awk '/^Host:/ {host=$2; hostname=$3} /^Ports:/ {print host, hostname, $0}' data/network/nmap_scan.txt | head -10
echo ""
EOF
    chmod +x "$SOLUTIONS_DIR/level5_solutions.sh"
}

generate_master_readme() {
    cat > "$PLAYGROUND_DIR/README.md" << 'EOF'
# 🎯 Grep & Find Mastery Playground

Welcome to your interactive Linux command-line training environment!

## 📚 What's Inside

This playground contains:
- **Real Linux Kernel Repository** - Practice git log analysis on actual kernel history
- **Realistic Sample Data** - Syslog files, network scans, user activity logs
- **5 Progressive Levels** - From beginner to master challenges
- **Complete Solutions** - Check your work against provided solutions

## 🚀 Getting Started

1. **Start with Level 1**: Open `LEVEL_1_BEGINNER.md`
2. **Try Each Challenge**: Run commands in your terminal
3. **Check Solutions**: When stuck, look at `solutions/level1_solutions.sh`
4. **Progress Through Levels**: Move to next level when comfortable

## 📖 Level Overview

### Level 1: Beginner - Basic Pattern Matching
- Simple grep searches
- Basic find operations
- File discovery
- **Time**: 30 minutes

### Level 2: Intermediate - Advanced Patterns & Regex
- Regular expressions
- Extended grep patterns
- Permission-based searches
- **Time**: 45 minutes

### Level 3: Advanced - Complex Queries & Git Log Analysis
- Multi-line context
- Git history exploration
- Command chaining
- **Time**: 1 hour

### Level 4: Expert - Network Analysis & Complex Pipelines
- Network data parsing
- Advanced git analysis
- Complex command pipelines
- **Time**: 1.5 hours

### Level 5: Master - Ultimate Challenges
- Security auditing
- Data aggregation
- Comprehensive analysis
- **Time**: 2 hours

## 🎓 Skills You'll Master

- **grep**: Pattern matching, regex, context searches
- **find**: File discovery, permission searches, time-based queries
- **git log**: Repository analysis, author searches, commit statistics
- **awk/sed**: Advanced text processing
- **Command Chaining**: Building powerful pipelines

## 📁 Directory Structure

```
grep-lab-playground/
├── README.md                  # This file
├── LEVEL_1_BEGINNER.md       # Level 1 challenges
├── LEVEL_2_INTERMEDIATE.md   # Level 2 challenges
├── LEVEL_3_ADVANCED.md       # Level 3 challenges
├── LEVEL_4_EXPERT.md         # Level 4 challenges
├── LEVEL_5_MASTER.md         # Level 5 challenges
├── data/                      # Sample data files
│   ├── logs/                 # System logs
│   ├── network/              # Network scan data
│   ├── users/                # User activity
│   └── config/               # Configuration files
├── linux-kernel/             # Real Linux kernel git repo
└── solutions/                # Solution scripts for each level
    ├── level1_solutions.sh
    ├── level2_solutions.sh
    ├── level3_solutions.sh
    ├── level4_solutions.sh
    └── level5_solutions.sh
```

## 💡 Tips

1. **Read the hints** - They point you in the right direction
2. **Man pages are your friend** - Try `man grep`, `man find`, `man git-log`
3. **Experiment freely** - This is a safe environment
4. **Check solutions** - Learning from examples is powerful
5. **Take breaks** - Complex patterns take time to understand

## 🔍 Quick Reference

### Common grep Options
- `-i`: Case insensitive
- `-v`: Invert match (exclude)
- `-c`: Count matches
- `-n`: Show line numbers
- `-A N`: Show N lines after match
- `-B N`: Show N lines before match
- `-E`: Extended regex
- `-o`: Only show matched part

### Common find Options
- `-name`: Search by filename
- `-type f`: Files only
- `-type d`: Directories only
- `-perm`: Search by permissions
- `-mtime`: Modified time
- `-size`: File size

### Common git log Options
- `--author`: Filter by author
- `--grep`: Search commit messages
- `--since`: Time range
- `--oneline`: Compact format
- `--stat`: Show statistics
- `--name-only`: Show changed files

## 🎉 Complete the Journey

Work through all 5 levels to become a command-line master!

Good luck! 🚀
EOF
}

################################################################################
# Main Execution
################################################################################

main() {
    print_banner
    
    log_info "Starting playground setup..."
    log_info "This will take 10-20 minutes depending on your connection speed"
    echo ""
    
    # Setup steps
    cleanup_old_playground
    create_directory_structure
    download_linux_kernel
    generate_sample_data
    generate_challenges
    
    # Success message
    echo ""
    log_success "==================================================="
    log_success "  PLAYGROUND SETUP COMPLETE!"
    log_success "==================================================="
    echo ""
    log_info "📍 Location: $PLAYGROUND_DIR"
    log_info "📖 Start here: $PLAYGROUND_DIR/README.md"
    log_info "🎯 First challenge: $PLAYGROUND_DIR/LEVEL_1_BEGINNER.md"
    echo ""
    log_info "To begin:"
    echo -e "  ${GREEN}cd $PLAYGROUND_DIR${NC}"
    echo -e "  ${GREEN}cat README.md${NC}"
    echo ""
    log_success "Happy learning! 🚀"
}

# Run main function
main "$@"
