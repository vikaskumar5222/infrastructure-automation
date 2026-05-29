#!/bin/bash

#--Configuration--
TARGET_DIR="$HOME/workspace/data"
BACKUP_DIR="$HOME/workspace/backup"
LOG_FILE="$HOME/workspace/backup.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
# ---------------------

#Ensure directories exists
mkdir -p "$TARGET_DIR" "$BACKUP_DIR"

# 1. Take the backup
echo "[${TIMESTAMP}] Starting backup of ${TARGET_DIR}..." >> "$LOG_FILE"
tar -czf "${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz" -C "$TARGET_DIR" . 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[${TIMESTAMP}] SUCCESS: Backup saved to ${BACKUP_DIR}" >> "$LOG_FILE"
else
    echo "[${TIMESTAMP}] ERROR: Backup failed!" >> "$LOG_FILE"
fi

# 2. Check Disk Space (Prints a warning if usage is over 80%)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "[${TIMESTAMP}] WARNING: Low disk space! Usage is at ${DISK_USAGE}%" >> "$LOG_FILE"
fi

echo "[${TIMESTAMP}] Automation script lifecycle complete." >> "$LOG_FILE"
