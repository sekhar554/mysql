#!/bin/bash

    #This Script use for backup of crontab files and entries
    #Modify as per your need

    mkdir -p /mnt/cron_backups
    for part in $(crontab -l | grep -v "clientmqueue" | sed 's/#.*//' | while read t1 t2 t3 t4 t5 main; do echo $main; done); do
      echo $part
    done | grep / | grep -v :// | while read -r row
                                      do
                                        scp $row /mnt/cron_backups/
                                        crontab -l > /mnt/cron_backups/backup_cron.txt 
                                        tar -cvzf  /mnt/cron_backups.tar.gz /mnt/cron_backups/

                                      done
    # grep -v is used for ignoring specific script with specific words or character 