
#Excluding DBS and dump

DATABASES_TO_EXCLUDE="db1 db2 db3"
EXCLUSION_LIST="'information_schema','mysql'"
for DB in `echo "${DATABASES_TO_EXCLUDE}"`
do
    EXCLUSION_LIST="${EXCLUSION_LIST},'${DB}'"
done
SQLSTMT="SELECT schema_name FROM information_schema.schemata"
SQLSTMT="${SQLSTMT} WHERE schema_name NOT IN (${EXCLUSION_LIST})"
MYSQLDUMP_DATABASES="--databases"
for DB in `mysql -ANe"${SQLSTMT}"`
do
    MYSQLDUMP_DATABASES="${MYSQLDUMP_DATABASES} ${DB}"
done
MYSQLDUMP_OPTIONS="--routines --triggers --single-transaction"
mysqldump -uroot -proot123 ${MYSQLDUMP_OPTIONS} ${MYSQLDUMP_DATABASES} > MySQLDatabases.sql