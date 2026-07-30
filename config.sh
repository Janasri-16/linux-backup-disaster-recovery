#!/bin/bash

############################################
# Project Root
############################################

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

############################################
# Directories
############################################

HOME_DIR="$PROJECT_ROOT/test-data/home"
ETC_DIR="$PROJECT_ROOT/test-data/etc"
WWW_DIR="$PROJECT_ROOT/test-data/www"

BACKUP_DIR="$PROJECT_ROOT/backups/daily"

RESTORE_DIR="$PROJECT_ROOT/restored-data"

LOG_DIR="$PROJECT_ROOT/logs"

LOG_FILE="$LOG_DIR/backup.log"

############################################
# Backup Settings
############################################

RETENTION=7

############################################
# Archive Settings
############################################

DATE_FORMAT="%Y-%m-%d_%H-%M-%S"

TIMESTAMP=$(date +"$DATE_FORMAT")
