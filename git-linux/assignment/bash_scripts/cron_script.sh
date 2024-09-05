#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Path to the ETL script
SCRIPT_PATH="./01_bash_etl/etl_bash_script.sh"

# Cron job schedule (0 0 * * * means every day at 12:00 AM)
CRON_SCHEDULE="0 0 * * *"

# Create the cron job line
CRON_JOB="$CRON_SCHEDULE $SCRIPT_PATH"

# Check if the cron job already exists
(crontab -l | grep -Fxq "$CRON_JOB") || (crontab -l; echo "$CRON_JOB") | crontab -