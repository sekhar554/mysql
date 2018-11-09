#!/bin/bash

date=$(date +%Y%m%d)
#dbname="SMPP_DB"
dbpass="root123"
dbuser="root"
#dbhost="localhost"

# Backup Dest directory, change this if you have someother location
DEST="/root/scripts/NSO_Backup/Tablewise/"

# Main directory where backup will be stored
MBD="$DEST/"`(date +%y%m%d)`
FILE=$MBD
mkdir /root/scripts/NSO_Backup/Tablewise/`(date +%y%m%d)`

# Store list of databases
DBS=""
# Store list of tables
TBS=""

# Get all database list first
DBS="$(mysql -u$dbuser -p$dbpass -Bse 'show databases')"

for db in $DBS
do
        mkdir $FILE/$db
        TBS="$(mysql -u$dbuser -p$dbpass $db -Bse "show tables")"
            for tb in $TBS
            do
                   mysqldump -u$dbuser -p$dbpass $db $tb --single-transaction > $FILE/$db/$tb'_'$date.sql 2>>/root/scripts/NSO_Backup/Tablewise/NSO.txt
                   gzip -9 $FILE/$db/$tb'_'$date.sql
            done
done












