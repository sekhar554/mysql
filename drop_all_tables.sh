#!/bin/bash
#
# Author: Rajasekhar S G
# MySQL DBA
#
# Script to drop all tables from database
#
#
TST=`date +%d%m%y%S`
read -p "Enter Database name:" DBN
read -p "Enter MySQL root Password:" MP
DBNM="$DBN"
MSP="$MP"
echo "Backing Up Database...."
echo ""
mysqldump -u root -p$MSP $DBNM > /tmp/"$DBNM"_"$TST".sql && echo "Database Backup Location: /tmp/"$DBNM"_"$TST".sql"
TLIST=`mysql -u root -p$MSP $DBNM -e 'show tables' | awk '{print $1}' | grep -v "Tables_in_$DBNM"`
for DRP in $TLIST
do
        echo "Dropping Table $DRP from Database $DBNM"
        mysql -u root -p$MSP $DBNM -e "SET FOREIGN_KEY_CHECKS = 0;"
        mysql -u root -p$MSP $DBNM -e "drop table $DRP"
        mysql -u root -p$MSP $DBNM -e "SET FOREIGN_KEY_CHECKS = 1;"
done
echo "If anything goes wrong, don't worry, Full backup of Database is at /tmp/"$DBNM"_"$TST".sql"
echo ""
echo "Report Bugs if any"

