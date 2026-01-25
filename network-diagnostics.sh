#!/bin/bash
# Network and Process Diagnostics Tool
# For advanced troubleshooting

echo "=========================================="
echo "MegaBank Network & Process Diagnostics"
echo "=========================================="
echo ""

echo "=== Service Status ==="
sudo systemctl status megabank-api --no-pager --lines=5
echo ""

echo "=== Port 8080 Usage ==="
echo "Using lsof:"
sudo lsof -i :8080 2>/dev/null || echo "  Port 8080 is free"
echo ""
echo "Using ss:"
sudo ss -tlnp | grep ":8080" || echo "  Port 8080 is free"
echo ""
echo "Using netstat:"
sudo netstat -tlnp 2>/dev/null | grep ":8080" || echo "  Port 8080 is free"
echo ""

echo "=== Database Port 5432 ==="
nc -zv localhost 5432 2>&1 | grep -q "succeeded" && echo "✓ PostgreSQL is reachable" || echo "✗ PostgreSQL is NOT reachable"
sudo systemctl status postgresql --no-pager --lines=3
echo ""

echo "=== Application Processes ==="
ps aux | grep -E "(megabank|banking-api)" | grep -v grep || echo "  No megabank processes running"
echo ""

echo "=== User 'bankapp' Processes ==="
ps aux | grep bankapp | grep -v grep || echo "  No processes running as bankapp"
echo ""

echo "=== Recent Journal Errors ==="
echo "Last 10 error lines from megabank-api service:"
sudo journalctl -u megabank-api | grep -i error | tail -10 || echo "  No errors found in journal"
echo ""

echo "=== File System Check ==="
echo "Application directory:"
sudo ls -la /opt/megabank/ 2>/dev/null || echo "  /opt/megabank/ does not exist"
echo ""
echo "Configuration directory:"
sudo ls -la /etc/megabank/ 2>/dev/null || echo "  /etc/megabank/ does not exist"
echo ""
echo "Log directory:"
sudo ls -la /var/log/megabank/ 2>/dev/null || echo "  /var/log/megabank/ does not exist"
echo ""

echo "=========================================="
echo "Diagnostics Complete"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  - Check detailed logs: sudo journalctl -u megabank-api -n 50"
echo "  - View service file: sudo systemctl cat megabank-api"
echo "  - Check syslog: sudo tail -100 /var/log/syslog | grep megabank"
