
#!/bin/bash

set -e

############################################
# Load Configuration
############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/config.sh"
source "$PROJECT_ROOT/functions.sh"
############################################
# Variables
############################################

BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

############################################
# Create Required Directories
############################################

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

############################################
# Logging
############################################

log_message "========================================="
log_message "Backup Started"
############################################
# Create Backup
############################################

tar -czf "$BACKUP_DIR/$BACKUP_NAME" \
    "$HOME_DIR" \
    "$ETC_DIR" \
    "$WWW_DIR"

############################################
# Verify Backup Creation
############################################

if [ -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
    log_message "Backup created successfully."
    success "Backup created successfully."
else
    log_message "Backup failed."
    error "Backup failed."
    exit 1
fi
############################################
# Backup Size
############################################

BACKUP_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)

log_message "Backup Size : $BACKUP_SIZE"
############################################
# Finish Logging
############################################

log_message "Backup Completed"
log_message "Backup File : $BACKUP_NAME"
log_message "========================================="
############################################
# Backup Rotation
############################################

bash "$PROJECT_ROOT/scripts/rotate.sh"

############################################
# Backup Verification
############################################

bash "$PROJECT_ROOT/scripts/verify_backup.sh"

############################################
# Success Message
############################################

echo

success "Backup Completed Successfully"

info "Backup File : $BACKUP_NAME"
info "Location    : $BACKUP_DIR"
info "Size        : $BACKUP_SIZE"

