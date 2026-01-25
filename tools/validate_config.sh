#!/bin/bash
# Configuration Validator for MegaBank
# This script validates all configuration files using Unix tools

CONFIG_DIR="config"
DB_ENV="$CONFIG_DIR/database.env"

echo "MegaBank Configuration Validator"
echo "================================"
echo ""

echo "Validating database.env..."
echo "-------------------------"

# Check if file exists
if [ ! -f "$DB_ENV" ]; then
    echo "✗ ERROR: $DB_ENV not found!"
    exit 1
fi

# Check for required variables
required_vars=("DB_HOST" "DB_PORT" "DB_NAME" "DB_USER" "DB_PASSWORD")

for var in "${required_vars[@]}"; do
    # BUG: grep pattern is wrong - won't match export statements correctly
    if grep -q "^$var=" "$DB_ENV"; then
        value=$(grep "^$var=" "$DB_ENV" | cut -d'=' -f2)
        echo "✓ $var is set: $value"
    else
        echo "✗ $var is missing!"
    fi
done

echo ""
echo "Checking for common issues..."
echo "----------------------------"

# TODO: Check if passwords contain special characters
# HINT: Use grep with regex pattern

# TODO: Check if port numbers are valid (1-65535)
# HINT: Use awk or grep with pattern matching

# TODO: Validate that DB_HOST is localhost or valid IP
# HINT: Use grep with IP address pattern

echo ""
echo "Validation complete!"
echo ""
echo "To fix issues, use:"
echo "  sed -i 's/old/new/g' $DB_ENV"
echo "  or edit manually with: vi $DB_ENV"
