#!/bin/bash
# Script variables
declare LOG_PURGE_HOUR=$(date +%H)
declare LOG_PURGE_MIN=$(date +%M)
declare B_PURGE=0
declare DATE_STAMP=$(date +%y%m%d)
declare CURRENT_DATE=$(date +%s)
declare LOG_DATE_STAMP="_$DATE_STAMP.log"
# User variables - Set these as necessary
declare ACCEPTABLE_DELAY=120
declare HOST="NSO_Localhost"
declare USERNAME=root
declare PASSWORD=root123
declare DB_HOST=192.168.0.11
declare LOG_PATH="/var/log/mysql/"  # path to log file, must end with "/"
declare LOG_PREFIX="slave_status"
declare MAIL_TO=sekhar.mysql2016@gmail.com,rajasekhar.s@gmail.com
# Computed script variables
let "EXPIRY_DATE=$CURRENT_DATE - 86400 * 14"  # expire archives older than 14 days
declare LOG=$LOG_PATH$LOG_PREFIX$LOG_DATE_STAMP
if test $LOG_PURGE_HOUR = "00"
then
   let B_PURGE=1
else
   let B_PURGE=0
fi
# Get the slave status from the server
mysql -u$USERNAME -p$PASSWORD -Nte "show slave status \G" > slave_status.txt
declare SLAVE_STATE=$(awk '/Slave_IO_State/ {print $2,$3,$4,$5,$6,$7,$8,$9,$10}' slave_status.txt)
declare DELAY=$(awk '/Seconds_Behind_Master/ {print $2}' slave_status.txt)
declare IO_THREAD=$(awk '/Slave_IO_Running/ {print $2}' slave_status.txt)
declare SQL_THREAD=$(awk '/Slave_SQL_Running/ {print $2}' slave_status.txt)
declare READ_MASTER_POSN=$(awk '/Read_Master_Log_Pos/ {print $2}' slave_status.txt)
declare RELAY_POSN=$(awk '/Relay_Log_Pos/ {print $2}' slave_status.txt)
declare EXEC_MASTER_POSN=$(awk '/Exec_Master_Log_Pos/ {print $2}' slave_status.txt)
declare RELAY_SPACE=$(awk '/Relay_Log_Space/ {print $2}' slave_status.txt)
echo -n "Slave Status Log: "                        >> $LOG
date                                                >> $LOG
echo "----------------------------------------"     >> $LOG
echo "Slave_IO_State:         "$SLAVE_STATE         >> $LOG
echo "Seconds_Behind_Master:  "$DELAY               >> $LOG
echo "Slave_IO_Running:       "$IO_THREAD           >> $LOG
echo "Slave_SQL_Running:      "$SQL_THREAD          >> $LOG
echo "Read_Master_Log_Pos:    "$READ_MASTER_POSN    >> $LOG
echo "Relay_Log_Pos:          "$RELAY_POSN          >> $LOG
echo "Exec_Master_Log_Pos:    "$EXEC_MASTER_POSN    >> $LOG
echo "Relay_Log_Space:        "$RELAY_SPACE         >> $LOG
echo "----------------------------------------"     >> $LOG
echo                                                >> $LOG
# Send message if IO thread dies
if test $IO_THREAD = "No"
then
   cat $LOG | mail -s "$HOST:  IO Thread Terminated" $MAIL_TO
fi
# Send message if SQL thread dies
if test $SQL_THREAD = "No"
then
   cat $LOG | mail -s "$HOST:  SQL Thread Terminated" $MAIL_TO
fi
#send message if slave falls more than ACCEPTABLE_DELAY behind
if test $DELAY -gt $ACCEPTABLE_DELAY
then
   cat $LOG | mail -s "$HOST:  Slave falling behind" $MAIL_TO
fi
# remove archives older than 10 days
if test $B_PURGE -eq 1
then
   for OLD_LOG in `ls $LOG_PATH`
   do
      let "FILE_DATE=`stat -c %Y $LOG_PATH/$OLD_LOG`"
      if test $FILE_DATE -lt $EXPIRY_DATE
      then
         rm -f $LOG_PATH/$OLD_LOG
      fi
   done
fi
# clean up
rm -r slave_status.txt