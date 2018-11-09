#Mysql KILL Query Script:

for PROC_TO_KILL in `mysql -h192.168.0.111 -uroot -proot123 -A --skip-column-names -e"SHOW PROCESSLIST" | grep -v "system user" | awk '{print $1}'` ; do mysql -h192.168.0.111 -uroot -proot123 -A --skip-column-names -e"KILL QUERY ${PROC_TO_KILL}" ; done