#!/bin/sh
#Procedures = For DB Backup
#Scheduled at : Every Day 22:00

v_path=/root/Pressu
logfile_path=/var/log/
v_file_name=DB_ATP
v_cnt=0

MAILTO="rajasekhar.s@infinitylabs.in"
touch "$logfile_path/sekhar_db_log.log"

#DB Backup
mysqldump -uroot -proot123 -h192.168.0.126 sekhar > $v_path/$v_file_name`date +%Y-%m-%d`.sql 
if [ "$?" -eq 0 ]
  then
   v_cnt=`expr $v_cnt + 1`
  mail -s "DB Backup has been done successfully" $MAILTO < $logfile_path/db_log.log
 else
   mail -s "Alert : kaka DB Backup has been failed" $MAILTO < $logfile_path/db_log.log
   exit
fi

db-backup.sh

#!/bin/bash

mysqldump -uroot -pCiscoinfi@2018 Infinity > InfinityDB.`date +%F_%T`.sql && echo "the mysqldump has been completed- status received at `date +%F_%T`|mail -s mysqldump-status sekhar.mysql2016@gmail.com