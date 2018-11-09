#!/bin/bash
 
DUMPDIR=/home/mysql/dumps
DATETIME=`date +%m%d%Y`
 
# individual database backups
for DB in db1 db2 db_n
do
        /usr/bin/mysqldump ${DB} > ${DUMPDIR}/${DB}.${DATETIME}
        /usr/bin/gzip -f ${DUMPDIR}/${DB}.${DATETIME}
done
 
# full database backup includes all databases
/usr/bin/mysqldump --all-databases > ${DUMPDIR}/full-dump.${DATETIME}
/usr/bin/gzip -f ${DUMPDIR}/full-dump.${DATETIME}
 
# Remove older backups > 7 days
/usr/bin/find ${DUMPDIR} -mtime +7 -print0 | xargs rm -rf
/usr/bin/find /mnt/samba -mtime +7 -print0 | xargs rm -rf 
 
# code to make off-line copies could go here....
# e.g. to samba mount point
#/bin/cp -r ${DUMPDIR} /mnt/samba