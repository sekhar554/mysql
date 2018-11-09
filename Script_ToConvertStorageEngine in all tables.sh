#!/bin/sh
 
MY_USER="root"
MY_PASSWORD="root"
MY_HOST="192.168.37.128"
MY_PORT=3306
NEW_ENGINE="InnoDB"
 
TABLES=`mysql -u$MY_USER -p$MY_PASSWORD -h$MY_HOST -P$MY_PORT -e"SELECT CONCAT(TABLE_SCHEMA,'.',TABLE_NAME) AS 'TABLE' FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('mysql','information_schema','performance_schema')"`
 
for TABLE in $TABLES; do
  echo -n "Converting: $TABLE ..."
  mysql -u$MY_USER -p$MY_PASSWORD -h$MY_HOST -P$MY_PORT -e"ALTER TABLE $TABLE ENGINE=$NEW_ENGINE;"
  echo "done"
done