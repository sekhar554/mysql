[root@NDB1 backup]# cat bkptblwise_gdp.sh

#!/bin/bash

#table=$( cat $1 )
date=$(date +%Y%m%d)
#dbname="SMPP_DB"
dbpass="root123"
dbuser="root"
#dbhost="localhost"

# Backup Dest directory, change this if you have someother location
DEST="/root/scripts/DBbackup/"

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

#    skipdb=-1
#    if [ "$IGGY" != "" ];
#    then
#        for i in $IGGY
#        do
#            [ "$db" == "$i" ] && skipdb=1 || :
#        done
#    fi
#    if [ "$skipdb" == "-1" ] ; then
#        FILE="$MBD/$db.$HOST.$NOW.gz"
#        # do all inone job in pipe,
#        # connect to mysql using mysqldump for select mysql database
#        # and pipe it out to gz file in backup dir :)
        mkdir $FILE/$db
        TBS="$(mysql -u$dbuser -p$dbpass $db -Bse "show tables")"
            for tb in $TBS
            do
                   mysqldump -u$dbuser -p$dbpass $db $tb --single-transaction > $FILE/$db/$tb'_'$date.sql 2>>/root/scripts/DBbackup/NSO.txt
                   gzip -9 $FILE/$db/$tb'_'$date.sql
            done

#    fi
done












#for t in $table
#do
#  echo -n "$t"
#  mysqldump -u$dbuser -p$dbpass $dbname "$t" > $FILE/$t$date.sql 2>/root/mine/logs/kk.txt
#  gzip -9 $FILE/$t$date.sql
#done
