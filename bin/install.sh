#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
CONFIG_SRC="${PROJECT_DIR}/config.cfg"
BIN_DIR="/usr/local/bin"
LOG_DIR="/var/log/capstone-maint"
mkdir -p "$LOG_DIR"
cp "${PROJECT_DIR}/bin/"*.sh "$BIN_DIR"
chmod +x "${BIN_DIR}/"*.sh
cp "$CONFIG_SRC" /etc/capstone-maint.conf
echo "Installed successfully."

