// Perfect One to rename database name- Feb-2018 - Tested:Live

#!/bin/bash

mysqlconn="mysql -u root -proot123"
olddb=$1
newdb=$2
$mysqlconn -e "CREATE DATABASE $newdb"
params=$($mysqlconn -N -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES \
                           WHERE table_schema='$olddb'")
for name in $params; do
      $mysqlconn -e "RENAME TABLE $olddb.$name to $newdb.$name";
done;
$mysqlconn -e "DROP DATABASE $olddb" //take care if rename fails proceeds for dropping old db

//run with sh rename.sh olddbname newdbname at linux console
