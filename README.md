## Automation

Automated using a cron job that runs every day at midnight.

### Cron Job
0 0 * * * /bin/bash /home/daudevops/backup-lab/scripts/backup.sh >> /home/daudevops/backup-lab/logs/cron_log.txt 2>&1

### Log Files
- Backup logs: ~/backup-lab/logs/backup_log.txt
- Cron logs: ~/backup-lab/logs/cron_log.txt
