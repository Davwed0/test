#!/bin/bash
# MegaBank Service Management Script
# Production Environment

SERVICE_NAME="megabank-api"
SYSTEMD_SERVICE="/etc/systemd/system/${SERVICE_NAME}.service"

case "$1" in
    start)
        echo "Starting MegaBank API service..."
        sudo systemctl start $SERVICE_NAME
        ;;
    stop)
        echo "Stopping MegaBank API service..."
        sudo systemctl stop $SERVICE_NAME
        ;;
    restart)
        echo "Restarting MegaBank API service..."
        sudo systemctl restart $SERVICE_NAME
        ;;
    status)
        echo "=== Service Status ==="
        sudo systemctl status $SERVICE_NAME --no-pager
        echo ""
        echo "=== Recent Logs (last 50 lines) ==="
        sudo journalctl -u $SERVICE_NAME -n 50 --no-pager
        ;;
    logs)
        echo "=== Following service logs (Ctrl+C to stop) ==="
        sudo journalctl -u $SERVICE_NAME -f
        ;;
    install)
        echo "Installing MegaBank API service..."
        # Copy service file
        sudo cp systemd/megabank-api.service $SYSTEMD_SERVICE
        
        # Create required directories
        sudo mkdir -p /opt/megabank
        sudo mkdir -p /var/log/megabank
        sudo mkdir -p /var/run/megabank
        sudo mkdir -p /etc/megabank
        
        # Copy application files
        sudo cp app.py /opt/megabank/banking-api.py
        sudo cp config/database.env /etc/megabank/database.conf
        
        # Set ownership (create user if doesn't exist)
        sudo useradd -r -s /bin/false bankapp 2>/dev/null || true
        sudo chown -R bankapp:bankapp /opt/megabank
        sudo chown -R bankapp:bankapp /var/log/megabank
        sudo chown -R bankapp:bankapp /var/run/megabank
        
        # Reload systemd
        sudo systemctl daemon-reload
        sudo systemctl enable $SERVICE_NAME
        
        echo "Service installed successfully!"
        echo "Use 'sudo systemctl start $SERVICE_NAME' to start"
        ;;
    uninstall)
        echo "Uninstalling MegaBank API service..."
        sudo systemctl stop $SERVICE_NAME 2>/dev/null || true
        sudo systemctl disable $SERVICE_NAME 2>/dev/null || true
        sudo rm -f $SYSTEMD_SERVICE
        sudo systemctl daemon-reload
        echo "Service uninstalled"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|install|uninstall}"
        exit 1
        ;;
esac
