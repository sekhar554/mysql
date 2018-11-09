#!/bin/sh
# MySQL_DeleteData.sh
# -----------------------------

#db_host="192.168.0.126"
db_user="root"
db_passwd="root123"
db="sekhar"
db_table="del_tab"
keep_records=4

## start id, you can change according your db
start_id=1

# mysql bin's path

#MYSQL="$(mysql)"

maxid=`mysql -u$db_user -p$db_passwd $db -e "select max(id) from $db_table"`

maxid=`echo $maxid |cut -d" " -f2`

#keep last 04 records
delto=`echo $maxid - $keep_records  |bc`

echo "target id: $delto"


i=$start_id
while [ $i -le $delto ]
do
 echo "delete to $i "

 echo "DELETE FROM $db_table where id<$i LIMIT 10 " | mysql -u $db_user -p$db_passwd $db
 true $(( i=i+9))

done

#Optimize the table to reclaim the space
mysql -u$db_user -p$db_passwd $db -e "alter table $db_table ENGINE='InnoDB'"