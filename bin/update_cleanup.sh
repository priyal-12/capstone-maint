#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
CONFIG="${SCRIPT_DIR}/config.cfg"
if [[ ! -f "$CONFIG" && -f /etc/capstone-maint.conf ]]; then CONFIG="/etc/capstone-maint.conf"; fi
source "$CONFIG"
mkdir -p "$LOG_DIR"
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi
if command -v apt-get >/dev/null 2>&1; then
apt-get update -y >>"$LOG_FILE" 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade >>"$LOG_FILE" 2>&1
apt-get -y autoremove >>"$LOG_FILE" 2>&1
apt-get -y clean >>"$LOG_FILE" 2>&1
elif command -v dnf >/dev/null 2>&1; then
dnf -y upgrade >>"$LOG_FILE" 2>&1
dnf -y autoremove >>"$LOG_FILE" 2>&1
dnf clean all >>"$LOG_FILE" 2>&1
elif command -v yum >/dev/null 2>&1; then
yum -y update >>"$LOG_FILE" 2>&1
yum -y autoremove >>"$LOG_FILE" 2>&1
yum clean all >>"$LOG_FILE" 2>&1
elif command -v pacman >/dev/null 2>&1; then
pacman -Syu --noconfirm >>"$LOG_FILE" 2>&1
pacman -Sc --noconfirm >>"$LOG_FILE" 2>&1
fi
if command -v journalctl >/dev/null 2>&1; then journalctl --vacuum-size=200M >>"$LOG_FILE" 2>&1; fi
echo "$(date) update complete" >> "$LOG_FILE"

