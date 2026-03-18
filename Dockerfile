# ==========================================
# Dockerfile : Backup Automation Container
# Author     : daudevops
# Date       : 19 March 2026
# ==========================================

# Start with Ubuntu base image
FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required tools
RUN apt-get update && apt-get install -y \
    bash \
    mysql-client \
    tar \
    cron \
    msmtp \
    msmtp-mta \
    mailutils \
    && rm -rf /var/lib/apt/lists/*

# Create folder structure
RUN mkdir -p /root/backup-lab/data && \
    mkdir -p /root/backup-lab/backups && \
    mkdir -p /root/backup-lab/logs && \
    mkdir -p /root/backup-lab/scripts	

# Copy backup script into container
COPY backup.sh /backup-lab/scripts/backup.sh

# SMTP 
RUN touch /root/.msmtprc && chmod 600 /root/.msmtprc

# Make script executable
RUN chmod +x /backup-lab/scripts/backup.sh

# Set working directory
WORKDIR /backup-lab

# Run the script when container starts
CMD ["/bin/bash", "/backup-lab/scripts/backup.sh"]
