#!/bin/bash
# Process Monitor for MegaBank Application
# Monitors and manages the banking application process

APP_NAME="app.py"
LOG_FILE="logs/app.log"

function show_status() {
    echo "Application Status"
    echo "=================="
    
    # Find process ID
    PID=$(pgrep -f "$APP_NAME")
    
    if [ -z "$PID" ]; then
        echo "Status: NOT RUNNING"
        return 1
    else
        echo "Status: RUNNING"
        echo "PID: $PID"
        
        # Show process details
        ps -p $PID -o pid,ppid,user,%cpu,%mem,etime,cmd
        
        # Show open ports
        echo ""
        echo "Open Ports:"
        lsof -p $PID -i -n 2>/dev/null | grep LISTEN || echo "  None"
    fi
}

function show_logs() {
    echo "Recent Log Entries"
    echo "=================="
    
    if [ -f "$LOG_FILE" ]; then
        # TODO: Use tail to show last 20 lines
        # TODO: Use grep to highlight ERROR entries
        # HINT: grep --color can add color highlighting
        tail -20 "$LOG_FILE"
    else
        echo "No log file found at $LOG_FILE"
    fi
}

function kill_app() {
    echo "Stopping Application..."
    
    PID=$(pgrep -f "$APP_NAME")
    
    if [ -z "$PID" ]; then
        echo "Application is not running"
        return 0
    fi
    
    # BUG: Using wrong signal - should use SIGTERM first, then SIGKILL if needed
    kill -9 $PID
    sleep 1
    
    # Verify it stopped
    if pgrep -f "$APP_NAME" > /dev/null; then
        echo "Failed to stop application"
        return 1
    else
        echo "Application stopped successfully"
        return 0
    fi
}

# Main script
case "$1" in
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    stop)
        kill_app
        ;;
    restart)
        kill_app
        sleep 2
        ./start_app.sh
        ;;
    *)
        echo "Usage: $0 {status|logs|stop|restart}"
        echo ""
        echo "Commands:"
        echo "  status  - Show application status and process info"
        echo "  logs    - Display recent log entries"
        echo "  stop    - Stop the application"
        echo "  restart - Restart the application"
        exit 1
        ;;
esac
