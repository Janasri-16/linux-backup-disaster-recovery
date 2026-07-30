#!/bin/bash

set -e

############################################
# Load Configuration
############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/config.sh"

############################################
# Logging
############################################

echo "=========================================" >> "$LOG_FILE"
echo "Restore Started : $(date)" >> "$LOG_FILE"

############################################
# Find Latest Backup
############################################

LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -n 1)

############################################
# Check Backup Exists
############################################

if [ -z "$LATEST_BACKUP" ]; then
    echo "No backup archive found!" | tee -a "$LOG_FILE"
    exit 1
fi

echo "Latest Backup : $LATEST_BACKUP" >> "$LOG_FILE"

############################################
# Prepare Restore Directory
############################################

rm -rf "$RESTORE_DIR"

mkdir -p "$RESTORE_DIR"

############################################
# Restore Backup
############################################

tar -xzf "$LATEST_BACKUP" -C "$RESTORE_DIR"

############################################
# Verify Restore
############################################

if [ -d "$RESTORE_DIR/test-data" ]; then

    echo "Restore completed successfully." >> "$LOG_FILE"

else

    echo "Restore failed." >> "$LOG_FILE"
    exit 1

fi

############################################
# Count Restored Files
############################################

RESTORED_FILES=$(find "$RESTORE_DIR" -type f | wc -l)

echo "Files Restored : $RESTORED_FILES" >> "$LOG_FILE"

############################################
# Finish Logging
############################################

echo "Restore Completed : $(date)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

############################################
# Success Message
############################################

echo
echo "========================================="
echo " Restore Completed Successfully"
echo "========================================="
echo "Backup File     : $(basename "$LATEST_BACKUP")"
echo "Restore Location: $RESTORE_DIR"
echo "Files Restored  : $RESTORED_FILES"
echo "========================================="
