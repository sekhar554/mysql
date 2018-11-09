#!/bin/bash

BACKUP_DIR=/var/backups/mysql/backups
BACKUP_PASS=root123
BACKUP_USER=root

DATE_DAY=$(date +"%Y-%m-%d")
DATE_HOUR=$(date +"%H")

EMAIL_RECIPIENT=rajasekhar.s@infinitylabs.in

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
fi



#Cron-Job
#You can then schedule it to run daily (crontab -e) at 04:00 in the morning for example:
#0 4 * * * /var/backups/mysql/make-mysql-backup.sh


#For 73 GB - Backup
#mysqldump takes 4Hrs 17Min  --mysqldump utility
#mysqlbackup takes 5.25Mins  --mysql enterprise backup

#For 73 GB - Restore
#mysqldump takes 18Hrs 45Min --mysqldump utility 
#mysqlbackup takes 14Mins    --mysql enterprise backup