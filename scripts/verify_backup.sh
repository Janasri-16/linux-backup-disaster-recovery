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
echo "Backup Verification Started : $(date)" >> "$LOG_FILE"

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

echo "Latest Backup : $(basename "$LATEST_BACKUP")" >> "$LOG_FILE"

############################################
# Verify Archive Integrity
############################################

if tar -tzf "$LATEST_BACKUP" > /dev/null 2>&1; then
    echo "Archive Integrity : PASSED" >> "$LOG_FILE"
else
    echo "Archive Integrity : FAILED" >> "$LOG_FILE"
    exit 1
fi

############################################
# Verify Required Files
############################################

REQUIRED_FILES=(
"test-data/home/Documents/document1.txt"
"test-data/etc/app.conf"
"test-data/www/index.html"
)

echo "Checking Required Files..." >> "$LOG_FILE"

for file in "${REQUIRED_FILES[@]}"
do
    if tar -tzf "$LATEST_BACKUP" | grep -q "$file"; then
        echo "[FOUND]   $file" >> "$LOG_FILE"
    else
        echo "[MISSING] $file" >> "$LOG_FILE"
    fi
done

############################################
# Backup Size
############################################

BACKUP_SIZE=$(du -h "$LATEST_BACKUP" | cut -f1)

echo "Backup Size : $BACKUP_SIZE" >> "$LOG_FILE"

############################################
# SHA256 Checksum
############################################

CHECKSUM=$(sha256sum "$LATEST_BACKUP" | awk '{print $1}')

echo "SHA256 Checksum :" >> "$LOG_FILE"
echo "$CHECKSUM" >> "$LOG_FILE"

############################################
# Count Files Inside Archive
############################################

FILE_COUNT=$(tar -tf "$LATEST_BACKUP" | wc -l)

echo "Files in Archive : $FILE_COUNT" >> "$LOG_FILE"

############################################
# Finish Logging
############################################

echo "Backup Verification Completed : $(date)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

############################################
# Success Message
############################################

echo
echo "========================================="
echo " Backup Verification Successful"
echo "========================================="
echo "Archive      : $(basename "$LATEST_BACKUP")"
echo "Backup Size  : $BACKUP_SIZE"
echo "Files        : $FILE_COUNT"
echo "SHA256       : $CHECKSUM"
echo "========================================="
