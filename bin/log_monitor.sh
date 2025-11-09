#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
CONFIG="${SCRIPT_DIR}/config.cfg"
if [[ ! -f "$CONFIG" && -f /etc/capstone-maint.conf ]]; then CONFIG="/etc/capstone-maint.conf"; fi
source "$CONFIG"
mkdir -p "$LOG_DIR"
LOG_FILES=(/var/log/syslog /var/log/auth.log /var/log/messages)
PATTERNS=("ERROR" "Failed" "CRITICAL")
> "$ALERT_FILE"
for f in "${LOG_FILES[@]}"; do
[[ -f "$f" ]] || continue
tail -n 500 "$f" | grep -E "${PATTERNS[*]}" >> "$ALERT_FILE" || true
done
echo "$(date) log check done" >> "$LOG_FILE"

