# Backup Automation Scripts

A collection of bash scripts to automate backup checking and reporting.
Built as part of my DevOps learning journey.

---

## About Me
- 25 year old Cloud Engineer at Accenture
- Currently working as Backup Administrator
- Transitioning to DevOps Engineer
- Learning by building real world projects

---

## Lab Environment

### Local Machine
- OS: Windows with WSL2 (Ubuntu 22.04)
- Database: MySQL (local)
- Editor: VS Code + Nano

---

## Project Structure
```
backup-lab/
├── data/          # Source data to back up
├── backups/       # Compressed backup files
├── logs/          # Backup and cron logs
└── scripts/       # Bash scripts
```

---

## Scripts

### backup.sh
- Backs up MySQL database using mysqldump
- Backs up application config and log files
- Compresses everything into a .tar.gz file
- Logs every step with timestamps
- Automatically deletes backups older than 7 days

---

## How to Run
```bash
chmod +x backup.sh
./backup.sh
```

---

## Automation

Automated using a cron job that runs every day at midnight.

### Cron Job
```
0 0 * * * /bin/bash /home/daudevops/backup-lab/scripts/backup.sh >> /home/daudevops/backup-lab/logs/cron_log.txt 2>&1
```

### Log Files
- Backup logs: ~/backup-lab/logs/backup_log.txt
- Cron logs: ~/backup-lab/logs/cron_log.txt

---

## Retention Policy
- Backups older than 7 days are automatically deleted
- Keeps disk usage under control
- Mirrors real enterprise backup policies

---

## What I Learned
- Bash scripting with variables, conditionals and functions
- MySQL database backup using mysqldump
- File compression using tar
- Cron job scheduling
- Git version control and GitHub
- Linux file permissions and navigation
