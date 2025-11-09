#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
CONFIG="${SCRIPT_DIR}/config.cfg"
if [[ ! -f "$CONFIG" && -f /etc/capstone-maint.conf ]]; then CONFIG="/etc/capstone-maint.conf"; fi
source "$CONFIG"
BACKUP_SCRIPT="${SCRIPT_DIR}/bin/backup.sh"
UPDATE_SCRIPT="${SCRIPT_DIR}/bin/update_cleanup.sh"
LOGMON_SCRIPT="${SCRIPT_DIR}/bin/log_monitor.sh"
while true; do
clear
echo "===== Maintenance Suite ====="
echo "1) Run Backup"
echo "2) Run System Update (sudo)"
echo "3) Run Log Monitor"
echo "4) View Logs"
echo "0) Exit"
read -rp "Enter choice: " opt
case "$opt" in
1) bash "$BACKUP_SCRIPT"; read -rp "Press Enter..." ;;
2) sudo bash "$UPDATE_SCRIPT"; read -rp "Press Enter..." ;;
3) bash "$LOGMON_SCRIPT"; read -rp "Press Enter..." ;;
4) less +G "$LOG_FILE" ;;
0) exit 0 ;;
*) echo "Invalid"; sleep 1 ;;
esac
done

