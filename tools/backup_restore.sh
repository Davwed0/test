#!/bin/bash
# Backup and Restore Script for MegaBank Configuration
# Uses Unix tools to backup and restore configurations

BACKUP_DIR="backups"
CONFIG_DIR="config"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

function create_backup() {
    echo "Creating backup..."
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Create tarball of config directory
    # TODO: Use tar to create compressed backup
    # HINT: tar -czf creates a gzipped tarball
    BACKUP_FILE="$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"
    
    tar -czf "$BACKUP_FILE" "$CONFIG_DIR" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Backup created: $BACKUP_FILE"
        
        # Show backup size
        ls -lh "$BACKUP_FILE" | awk '{print "  Size: " $5}'
    else
        echo "✗ Backup failed!"
        return 1
    fi
}

function list_backups() {
    echo "Available Backups"
    echo "================="
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "No backups found"
        return 0
    fi
    
    # TODO: Use find to locate all backup files
    # TODO: Use awk to format output nicely
    find "$BACKUP_DIR" -name "*.tar.gz" -type f | sort -r
}

function restore_backup() {
    if [ -z "$1" ]; then
        echo "ERROR: Please specify backup file"
        echo "Usage: $0 restore <backup_file>"
        list_backups
        return 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "ERROR: Backup file not found: $BACKUP_FILE"
        return 1
    fi
    
    echo "Restoring from backup: $BACKUP_FILE"
    
    # Create backup of current config before restoring
    echo "Creating safety backup of current config..."
    create_backup
    
    # Extract backup
    # TODO: Use tar to extract the backup
    # HINT: tar -xzf extracts a gzipped tarball
    tar -xzf "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✓ Restore completed successfully"
    else
        echo "✗ Restore failed!"
        return 1
    fi
}

# Main script
case "$1" in
    backup)
        create_backup
        ;;
    list)
        list_backups
        ;;
    restore)
        restore_backup "$2"
        ;;
    *)
        echo "Usage: $0 {backup|list|restore}"
        echo ""
        echo "Commands:"
        echo "  backup         - Create a new backup of configurations"
        echo "  list           - List all available backups"
        echo "  restore <file> - Restore from specified backup file"
        exit 1
        ;;
esac
