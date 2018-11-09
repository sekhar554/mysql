#!/bin/bash

BACKUP_DIR=/root/scripts/NSO_Backup
BACKUP_PASS=mysupersecret
BACKUP_USER=backup

DATE_DAY=$(date +"%Y-%m-%d")
DATE_HOUR=$(date +"%H")

EMAIL_RECIPIENT=simon@krenger.ch

/usr/local/mysql/bin/mysqlbackup --port=3306 --protocol=tcp --user=$BACKUP_USER --password=$BACKUP_PASS --with-timestamp --backup-dir=$BACKUP_DIR backup-and-apply-log

NO_OF_COMPLETE_OK_MESSAGES=$(cat $BACKUP_DIR/${DATE_DAY}_${DATE_HOUR}*/meta/MEB_${DATE_DAY}.${DATE_HOUR}*.log | grep "mysqlbackup completed OK" | wc -l)

# Note that the string "mysqlbackup completed OK" must occur 2 times in the log in order for the backup to be OK
if [ $NO_OF_COMPLETE_OK_MESSAGES -eq 2 ]; then
        # Backup successful, find backup directory
        echo "Backup succeeded"
        exit 0
else
        echo "MySQL backup failed, please check logfile" | mail -s "ERROR: MySQL Backup Failed!" ${EMAIL_RECIPIENT}
        exit 1
find