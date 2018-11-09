MYSQL_USER=root
MYSQL_PASS=root123
MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PASS} -h192.168.0.117 -P3306 --protocol=tcp"
SQL="SET GLOBAL innodb_fast_shutdown = 0"
mysql ${MYSQL_CONN} -ANe"${SQL}"
mysqladmin ${MYSQL_CONN} shutdown
cd /var/lib/mysql
rm -f ib_logfile*
service mysql start