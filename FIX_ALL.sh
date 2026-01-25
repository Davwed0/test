#!/bin/bash
# Automatic Solution Script - For Testing or Emergency Use Only
# This script automatically fixes all Unix issues in the banking simulation

echo "========================================"
echo "MegaBank Unix Issues - Auto Fix Script"
echo "========================================"
echo ""
echo "⚠️  This script will automatically fix all issues."
echo "    Students should NOT use this - it's for testing only!"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

# Track progress
fixed=0
total=8

echo "[1/$total] Fixing file permissions..."
chmod +x start_app.sh database/setup_db.sh monitoring/health_check.sh test_api.sh
((fixed++))
echo "✓ File permissions fixed"
echo ""

echo "[2/$total] Converting DOS line endings to Unix..."
if command -v dos2unix &> /dev/null; then
    dos2unix start_app.sh 2>/dev/null
else
    sed -i 's/\r$//' start_app.sh
fi
((fixed++))
echo "✓ Line endings converted"
echo ""

echo "[3/$total] Fixing Python command (python -> python3)..."
sed -i 's/^python /python3 /' start_app.sh
((fixed++))
echo "✓ Python command fixed"
echo ""

echo "[4/$total] Fixing database password..."
sed -i 's/DB_PASSWORD=BankSecure2024$/DB_PASSWORD=BankSecure2024!/' config/database.env
((fixed++))
echo "✓ Database password fixed"
echo ""

echo "[5/$total] Fixing SQL syntax errors..."
sed -i "10s/$/;/" database/init_db.sql
sed -i "22s/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP$/last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP)/" database/init_db.sql
((fixed++))
echo "✓ SQL syntax fixed"
echo ""

echo "[6/$total] Fixing database setup script path..."
sed -i 's|psql -f init_db.sql|psql -f database/init_db.sql|' database/setup_db.sh
((fixed++))
echo "✓ Database script path fixed"
echo ""

echo "[7/$total] Fixing health check script variable..."
sed -i 's/\$HEALTH_URL/\$HEALTH_ENDPOINT/g' monitoring/health_check.sh
((fixed++))
echo "✓ Health check variable fixed"
echo ""

echo "[8/$total] Fixing port number check..."
sed -i 's/5433/5432/g' start_app.sh
((fixed++))
echo "✓ Port number fixed"
echo ""

echo "========================================"
echo "✓ All $fixed/$total issues fixed!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Initialize database: cd database && sudo ./setup_db.sh"
echo "2. Install dependencies: pip3 install -r requirements.txt"
echo "3. Start application: ./start_app.sh"
echo "4. Test API: curl http://localhost:8080/health"
echo ""
echo "Or run: ./test_api.sh (after starting the app)"
