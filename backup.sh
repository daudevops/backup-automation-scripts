#!/bin/bash

# =========================================
# Script  : backup.sh
# Purpose : Back up MySQL DB + files + logs
# Author  : Mohammad Daud
# Role    : Cloud Engineer / Backup Administrator
# Date    : 15 March 2026 
# Version : 1.0
# =========================================

# --- Variables ---
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR=~/backup-lab/backups
LOG_FILE=~/backup-lab/logs/backup_log.txt
DATA_DIR=~/backup-lab/data
DB_NAME="backup_lab_db"
DB_USER="root"
EMAIL="daudevops@gmail.com"

# --- Email Alert Function ---
send_alert() {
    local MESSAGE=$1
    echo "$MESSAGE" | mail -s "🚨 Backup Alert - $(hostname) - $DATE" "$EMAIL"
    echo "[$DATE] ALERT SENT: $MESSAGE" | tee -a "$LOG_FILE"
}

# --- Create backup folder for today ---
mkdir -p "$BACKUP_DIR/$DATE"

echo "[$DATE] ========== Backup Started ==========" | tee -a "$LOG_FILE"

# --- Step 1: Backup MySQL Database ---
echo "[$DATE] Starting database backup..." | tee -a "$LOG_FILE"

mysqldump -h 172.17.0.1 -u backupuser -ppassword123 "$DB_NAME" > "$BACKUP_DIR/$DATE/${DB_NAME}_backup.sql" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$DATE] SUCCESS: Database backup completed." | tee -a "$LOG_FILE"
else
    echo "[$DATE] ERROR: Database backup failed!" | tee -a "$LOG_FILE"
    send_alert "ERROR: Database backup failed on $(hostname). Please check logs at $LOG_FILE"
fi

# --- Step 2: Backup Data Files ---
echo "[$DATE] Starting file backup..." | tee -a "$LOG_FILE"

cp -r "$DATA_DIR" "$BACKUP_DIR/$DATE/data_files" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$DATE] SUCCESS: File backup completed." | tee -a "$LOG_FILE"
else
    echo "[$DATE] ERROR: File backup failed!" | tee -a "$LOG_FILE"
	send_alert "ERROR: Database backup failed on $(hostname). Please check logs at $LOG_FILE"
fi

# --- Step 3: Compress Everything ---
echo "[$DATE] Compressing backup..." | tee -a "$LOG_FILE"

tar -czf "$BACKUP_DIR/backup_${DATE}.tar.gz" -C "$BACKUP_DIR" "$DATE/" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$DATE] SUCCESS: Backup compressed to backup_${DATE}.tar.gz" | tee -a "$LOG_FILE"
    # Remove uncompressed folder
    rm -rf "$BACKUP_DIR/$DATE"
else
    echo "[$DATE] ERROR: Compression failed!" | tee -a "$LOG_FILE"
	send_alert "ERROR: Database backup failed on $(hostname). Please check logs at $LOG_FILE"
fi


# --- Step 4: Retention Policy - Delete backups older than 7 days ---
echo "[$DATE] Starting retention policy cleanup..." | tee -a "$LOG_FILE"

find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +7 -type f -delete

if [ $? -eq 0 ]; then
    echo "[$DATE] SUCCESS: Old backups cleaned up successfully." | tee -a "$LOG_FILE"
else
    echo "[$DATE] ERROR: Retention cleanup failed!" | tee -a "$LOG_FILE"
	send_alert "ERROR: Database backup failed on $(hostname). Please check logs at $LOG_FILE"
fi

echo "[$DATE] ========== Backup Completed ==========" | tee -a "$LOG_FILE"

# --- Send Success Alert ---
echo "Backup completed successfully on $(hostname) at $DATE. Check logs at $LOG_FILE" | mail -s "✅ Backup Success - $(hostname) - $DATE" "$EMAIL"
echo "[$DATE] SUCCESS ALERT SENT" | tee -a "$LOG_FILE"

echo "" >> "$LOG_FILE"
