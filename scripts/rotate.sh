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
echo "Backup Rotation Started : $(date)" >> "$LOG_FILE"

############################################
# Count Existing Backups
############################################

BACKUP_COUNT=$(find "$BACKUP_DIR" -type f -name "*.tar.gz" | wc -l)

echo "Current Backup Count : $BACKUP_COUNT" >> "$LOG_FILE"

############################################
# Check Retention Policy
############################################

if [ "$BACKUP_COUNT" -le "$RETENTION" ]; then
    echo "Rotation not required." >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    exit 0
fi

############################################
# Delete Old Backups
############################################

OLD_BACKUPS=$(ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +$((RETENTION + 1)))

for backup in $OLD_BACKUPS
do
    echo "Deleting Old Backup : $backup" >> "$LOG_FILE"
    rm -f "$backup"
done

############################################
# Finish Logging
############################################

REMAINING=$(find "$BACKUP_DIR" -type f -name "*.tar.gz" | wc -l)

echo "Remaining Backups : $REMAINING" >> "$LOG_FILE"
echo "Backup Rotation Completed : $(date)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

############################################
# Terminal Output
############################################

echo
echo "========================================="
echo " Backup Rotation Completed"
echo "========================================="
echo "Retention Policy : Keep Latest $RETENTION Backups"
echo "Current Backups  : $REMAINING"
echo "========================================="

