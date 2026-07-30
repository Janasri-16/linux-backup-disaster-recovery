#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CRON_JOB="0 2 * * * cd $PROJECT_DIR && ./scripts/backup.sh >> logs/cron.log 2>&1"

(crontab -l 2>/dev/null | grep -F "$CRON_JOB") >/dev/null

if [ $? -eq 0 ]; then
    echo "Cron job already exists."
else
    (
        crontab -l 2>/dev/null
        echo "$CRON_JOB"
    ) | crontab -

    echo "Cron job added successfully."
fi
