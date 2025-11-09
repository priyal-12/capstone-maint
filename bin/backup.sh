#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
CONFIG="${SCRIPT_DIR}/config.cfg"
if [[ ! -f "$CONFIG" && -f /etc/capstone-maint.conf ]]; then CONFIG="/etc/capstone-maint.conf"; fi
source "$CONFIG"
mkdir -p "$BACKUP_TARGET" "$LOG_DIR"
LOCKFILE="/var/lock/capstone-backup.lock"
{
flock -n 9 || { echo "$(date) another backup running" >> "$LOG_FILE"; exit 1; }
TS="$(date +%F_%H%M%S)"
BACKUP_NAME="capstone-backup-${TS}.tar.gz"
BACKUP_PATH="${BACKUP_TARGET}/${BACKUP_NAME}"
tar czpf "$BACKUP_PATH" $BACKUP_SOURCE 2>>"$LOG_FILE"
ls -1t "$BACKUP_TARGET"/capstone-backup-*.tar.gz 2>/dev/null | tail -n +$((KEEP_COUNT+1)) | while read -r old; do rm -f "$old"; done
echo "$(date) backup completed: $BACKUP_PATH" >> "$LOG_FILE"
} 9>"$LOCKFILE"

