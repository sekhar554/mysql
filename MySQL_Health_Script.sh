#!/bin/bash
#
# Developed by Itchy Ninja Software
# 9/15/2015
#
# This script connects to a MySQL server and performs a number of health checks.
# The idea is for this to be used by a first level support team, who is not skilled
# in MySQL database administration, to allow them to determine whether an alert they
# may have received for a MySQL server is valid.  We wrote this when a client was
# continually receiving alerts from a monitor that there was a problem and started
# paging out the MySQL DBAs as a result for several false alarms due to an issue
# with the monitor.
#
# The color code was borrowed from tuning-primer.sh.
# This code was a combination of scripts and code snippets collected over the years.
# Connectivity
MYSQL_USER="root"
MYSQL_PASSWORD="secret"
 
MYSQL=`which mysql`
MYSQLADMIN=`which mysqladmin`
 
export black='\033[0m'
export boldblack='\033[1;0m'
export red='\033[31m'
export boldred='\033[1;31m'
export green='\033[32m'
export boldgreen='\033[1;32m'
export yellow='\033[33m'
export boldyellow='\033[1;33m'
export blue='\033[34m'
export boldblue='\033[1;34m'
export magenta='\033[35m'
export boldmagenta='\033[1;35m'
export cyan='\033[36m'
export boldcyan='\033[1;36m'
export white='\033[37m'
export boldwhite='\033[1;37m'
 
# Define an array for advice
ADVICE=()
 
function show_time() {
  num=$1
  min=0
  hour=0
  if((num>59));then
    ((sec=num%60))
    ((num=num/60))
    if((num>59));then     
      ((min=num%60))              
      ((num=num/60))                
      ((hour=num))
    else
      ((min=num))                 
    fi
  else
    ((sec=num))
  fi
 
  if [ $hour -lt 10 ]; then
    hour="0$hour"
  fi
  if [ $min -lt 10 ]; then
    min="0$min"
  fi
  if [ $sec -lt 10 ]; then
    sec="0$sec"
  fi
  echo "$hour:$min:$sec"
}
 
function cecho () {
  local default_msg=""
  message=${1:-$default_msg}	# Defaults to default message.
 
  #change it for fun
  #We use pure names
  color=${2:-black}		# Defaults to black, if not specified.
 
  case $color in
	black)
		 printf "$black" ;;
	boldblack)
		 printf "$boldblack" ;;
	red)
		 printf "$red" ;;
	boldred)
		 printf "$boldred" ;;
	green)
		 printf "$green" ;;
	boldgreen)
		 printf "$boldgreen" ;;
	yellow)
		 printf "$yellow" ;;
	boldyellow)
		 printf "$boldyellow" ;;
	blue)
		 printf "$blue" ;;
	boldblue)
		 printf "$boldblue" ;;
	magenta)
		 printf "$magenta" ;;
	boldmagenta)
		 printf "$boldmagenta" ;;
	cyan)
		 printf "$cyan" ;;
	boldcyan)
		 printf "$boldcyan" ;;
	white)
		 printf "$white" ;;
	boldwhite)
		 printf "$boldwhite" ;;
  esac
 
  printf "%s\n"  "$message"
  tput sgr0			# Reset to normal.
  printf "$black"
 
  return
}
 
function replication() { 
  LAST_ERRNO=$(echo $SLAVE_STATUS | grep "Last_Errno" | awk '{ print $2 }') 
  IO_IS_RUNNING=$(echo $SLAVE_STATUS | grep "Slave_IO_Running" | awk '{ print $2 }') 
  SQL_IS_RUNNING=$(echo $SLAVE_STATUS | grep "Slave_SQL_Running" | awk '{ print $2 }') 
 
  # Check for replication slave
  echo -n "Replication slave: "
  SLAVE_STATUS=`run_mysql_cmd "SHOW SLAVE STATUS\G"`
  if [ -n $SLAVE_STATUS ]; then
    cecho "N/A" yellow
  else
    cecho "YES" yellow
 
    ### Run Some Checks ###  
    ## Check For Last Error ## 
    echo -n "Checking for errors in replication: "
    if [ "$LAST_ERRNO" != 0 ]; then 
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Errors found in replication.  You may want to call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi 
  
    ## Check if IO thread is running ## 
    echo -n "Verify replication I/O thread running: "
    if [ "$IO_IS_RUNNING" != "Yes" ]; then 
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Replication I/O thread does not appear to be running.  Login to MySQL and execute 'START SLAVE IO_THREAD;' and then 'SHOW SLAVE STATUS' to see if it starts.  If not, call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi 
 
    ## Check for SQL thread ## 
    echo -n "Verify replication SQL thread running: "  
    if [ "$SQL_IS_RUNNING" != "Yes" ]; then 
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Replication I/O thread does not appear to be running.  Login to MySQL and execute 'START SLAVE SQL_THREAD;' and then 'SHOW SLAVE STATUS' to see if it starts.  If not, call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
  fi 
}
 
function pxc() {
  # Check for Percona Cluster Node
  echo -n "Galera (PXC) cluster: "
  PXC_STATUS=`run_mysql_cmd "SHOW GLOBAL STATUS LIKE 'wsrep%'\G"`
  if [ -n $PXC_STATUS ]; then
    cecho "N/A" yellow
  else
    cecho "YES" yellow
 
    STATE=$(echo $PXC_STATUS | grep "wsrep_local_state_comment" | awk '{ print $2 }') 
    CLUSTER_STATUS=$(echo $PXC_STATUS | grep "wsrep_cluster_status" | awk '{ print $2 }') 
    WSREP_READY=$(echo $PXC_STATUS | grep "wsrep_ready" | awk '{ print $2 }') 
    CLUSTER_SIZE=$(echo $PXC_STATUS | grep "wsrep_cluster_size" | awk '{ print $2 }') 
 
    echo "Cluster Size: $CLUSTER_SIZE"
    echo "Cluster Status: $CLUSTER_STATUS"
    echo "Local Node Status: $STATE"
    echo "Replication: $WSREP_READY"
 
    echo -n "Cluster node is in primary status: "
    if [ "$CLUSTER_STATUS" <> "Primary" ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Cluster node is in non-primary state.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
 
    echo -n "Cluster size is at least three nodes: "
    if [ $CLUSTER_SIZE -ge 3 ]; then
      cecho "FAIL"  boldred
      ADVICE=("${ADVICE[@]}" "Cluster node does not seem to have at least three nodes.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
 
    echo -n "Cluster node is in synced with cluster: "
    if [ "$STATE" <> "Synced" ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Cluster node is not synced.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
 
    echo -n "Cluster node is replicating with cluster: "
    if [ "$WSREP_READY" <> "ON" ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Cluster node is not replicating.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
  fi
}
 
function processlist() {
  MAX_CONNECTIONS=$(get_mysql_var "max_connections")
  CURRENT_CONNECTIONS=1
  CURRENT_CONNECTIONS=$(get_mysql_status_var "Threads_connected")
  CONNPCT=$(echo "scale=2; $CURRENT_CONNECTIONS / $MAX_CONNECTIONS * 100" | bc)
  CONN=$(roundit $CONNPCT 0)
 
  echo -n "Currently running processes: "
  if [ "$CONN" -gt 10 ]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "MySQL currently has $CURRENT_CONNECTIONS connections which is $CONN% of its maximum allowed ($MAX_CONNECTIONS) connections.  Call a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
 
  # Check the processlist
  PROCESSLIST=`run_mysql_cmd "SELECT * FROM information_schema.PROCESSLIST"`
  if [[ $PROCESSLIST = "" ]]; then
    echo "No processes found."
  else
    GLOBAL_READ_LOCK=$(echo $PROCESSLIST | grep "Waiting for global read lock" | awk '{ print $2 }')
    COMMIT_LOCK=$(echo $PROCESSLIST | grep "Waiting for commit lock" | awk '{ print $2 }')
 
    echo -n "Processes in global read lock: "
    if [ ! -z $GLOBAL_READ_LOCK ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Processes found in 'waiting for global read lock' state.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
 
    echo -n "Processes waiting for commit lock: "
    if [ ! -z $COMMIT_LOCK ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "FLUSH TABLES WITH READ LOCK is waiting for a commit lock.  Call a MySQL DBA!")
    else
      cecho "PASS" boldgreen
    fi
  fi
}
 
function get_mysql_var() {
  VAR=$($MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1 -sNe "SHOW GLOBAL VARIABLES LIKE '$1'" 2> /dev/null | awk '{ print $2 }')
  echo $VAR
}
 
function errorlog() {
  ERRORLOG="`get_mysql_var "log_error"`"
  TS=`date +%Y-%m-%d`
  
  #if [ -f $ERRORLOG ]; then
  #  NUMERRORS=`cat $ERRORLOG | grep "\[ERROR\]" | tail -10 | wc -l`    
  #  if [ $NUMERRORS -gt 0 ]; then
  #    cat $ERRORLOG | grep "\[ERROR\]" | tail -10
  #  else
  #    echo "No matching log entries found."
  #  fi
  #fi
 
  echo -n "MySQL error log: "
  if [ -r $ERRORLOG ]; then
    NUMERRORS=`cat $ERRORLOG 2> /dev/null | grep "$TS" | wc -l` 
    if [ $NUMERRORS -gt 0 ]; then
      cecho "FAIL" boldred
      ADVICE=("${ADVICE[@]}" "Error log entries found for today.  Read the log entries and determine whether a MySQL DBA is needed.")
      echo "Error log entries found:"
      cat $ERRORLOG | grep "$TS"
    else
      cecho "PASS" boldgreen
    fi
  else 
    cecho "FAIL" boldyellow
    ADVICE=("${ADVICE[@]}" "Could not open the MySQL Error Log, $ERRORLOG.  Change to either the 'mysql' or 'root' user and try again.")
  fi
}
 
function get_mysql_status_var() {
  VAR=$($MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1 -sNe "SHOW GLOBAL STATUS LIKE '$1'" 2> /dev/null | awk '{ print $2 }')
  echo $VAR
}
 
function header() {
  cecho "==============================================================" boldblue
  cecho "= $1" boldblue
  cecho "==============================================================" boldblue
}
 
function health() {
  # Get datadir from MySQL
  DATADIR="`get_mysql_var "datadir"`"
 
  GLOBAL_STATUS="`run_mysql_cmd "SHOW GLOBAL STATUS LIKE 'Uptime'"`"
  UPTIME=$(get_mysql_status_var 'Uptime')
  THREADS_CREATED=$(get_mysql_status_var 'Threads_created')
 
  echo -n "MySQL uptime: "
  if [ "$UPTIME" -lt 86400 ]; then
    cecho "WARNING" boldyellow 
    UP=$(show_time $UPTIME)
    ADVICE=("${ADVICE[@]}" "The mysqld process was restarted in the past 24 hours and has been up $UP.")
  else
    cecho "PASS" boldgreen
  fi
}
 
function roundit() {
  LC_ALL=C printf "%.*f\n" $2 $1
}
 
function system_metrics() {
  PROCS=$(echo "($(echo "$(grep -c proc /proc/cpuinfo)/3" | bc -l)+0.9)/1" | bc)
 
  LOADAVG=$(cat /proc/loadavg | awk '{ print $1 }' | cut -d '%' -f 1)
  LOAD=$(roundit $LOADAVG 0)
  echo -n "System load average: "
  if [ "$LOAD" -gt "$PROCS" ]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "The load average is, $LOADAVG, which indicates that all CPUs are fully utilized.  You may want to reach out to Linux Admins and a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
 
  MEMORYUSED=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  MEM=$(roundit $MEMORYUSED 0) 
  echo -n "Memory usage: "
  if [ "$MEM" -ge 95 ]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "It appears $MEM% of the RAM is in use.  You may want to reach out to Linux Admins and a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
 
  DISKUSAGE=$(df -h $DATADIR | awk '{ print $5 }' | tail -n 1 | cut -d '%' -f 1)
  DISKPCT=$(roundit $DISKUSAGE 0) 
  echo -n "Disk usage: "
  if [ "$DISKPCT" -ge 95 ]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "Over 95% of the disk is in use.  You may want to reach out to a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
 
  CPUUSAGE=$(top -bn1 | awk '/Cpu/ { cpu = 100 - $8 }; END { print cpu }')
  CPU=$(roundit $CPUUSAGE 0)
  echo -n "CPU usage: "
  if [ "$CPU" -ge 95 ]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "It appears $CPUUSAGE% of the CPU is utilized.  You may want to reach out to Linux Admins and a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
 
  SWAPUSAGE=$(top -bn1 | awk '/Swap/ { swap = $7 / $3 * 100 }; END { print swap }')
  SWAPPCT=$(roundit $SWAPUSAGE 0)
  echo -n "Swap usage: "
  if [[ $SWAPPCT -ge 50 ]]; then
    cecho "FAIL" boldred
    ADVICE=("${ADVICE[@]}" "It appears $SWAPPCT% of the CPU is utilized.  You may want to reach out to Linux Admins and a MySQL DBA!")
  else
    cecho "PASS" boldgreen
  fi
}
 
function run_mysql_cmd() {
  eval "$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1 -sNe \"$1\" 2> /dev/null"
}
 
function display_advice() {
  # Display advice
  echo
  header "Recommended Action"
  if [ "${#ADVICE[@]}" -gt 0 ]; then
    for i in $(seq 0 ${#ADVICE[@]}) ; do cecho "${ADVICE[$i]}" boldred ; done
  else
    cecho "No issues with MySQL could be detected by this script." boldgreen
  fi
}
 
# Get the datadir from MySQL
 
 
### Main Code
header "MySQL Health Check"
 
echo -n "MySQL connection: "
MYSQL_USEROPTIONS="-u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1"
if ! $MYSQLADMIN $MYSQL_USEROPTIONS ping > /dev/null 2>&1; then
  cecho "FAIL" boldred
  ADVICE=("${ADVICE[@]}" "MySQL does not seem to be running or supplied username/password is not correct.  You can check whether MySQL is running with 'service mysql status' or 'ps ax | grep mysqld'.  If it is down, you may start MySQL with 'service mysql start' and try this script again.  If that fails, you may want to call a MySQL DBA!")
  system_metrics
  display_advice
  exit 1
else
  cecho "PASS" boldgreen
  health
  processlist
  replication
  pxc
  system_metrics
  errorlog
  display_advice
fi