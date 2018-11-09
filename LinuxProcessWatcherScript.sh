#!/bin/sh
#
# watchprocess.sh
# Simple bash script that runs and waits for a PID to terminate and then sends an email
#
# To have the script email when a job is complete for example, do something like this:
# ./watchprocess.sh 12345
#
 
# Configuration
MAILTO="webmaster@itchyninja.com"
HOSTNAME=`hostname`
 
# Get options from the command line
PROGRAM="watchprocess.sh"
PID=$1
USAGE=0
 
# Make sure a process ID was provided
if [ "$PID" == "" ]; then
  USAGE=1;
  echo "Please specify a PID to watch."
fi
 
# Show usage if needed
if [ "$USAGE" == "1" ]; then
  echo "usage: $PROGRAM PID CMD"
  echo " PID = Process ID to watch for completion"
  echo " COMMAND = Command to be executed when process completes"
  exit
fi
 
# Verify the process is actually running
pgrep -f "${PID}" >/dev/null 2>&1
STATUS=$?
if [ ${STATUS} -eq 0 ]; then
  # Wait for process to complete
  while test -d /proc/$PID; do
    sleep 1
    pgrep -f "${PID}" >/dev/null 2>&1
    STATUS=$?
  done
 
  # Send the email now that is done
  echo "Process [$PID] has completed on ${HOSTNAME}" | mailx -s "Process [$PID] Complete" ${MAILTO}
else
  echo "The process with ID, $PID, does not seem to be running.  Exiting without sending email..."
fi