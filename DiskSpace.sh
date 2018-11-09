#!/bin/bash
#
# This script does a very simple test for checking disk space.
#
# Itchy Ninja Software: http://www.itchyninja.com
#
 
CHECKDISK=`df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -`
ALERT_VALUE="80"
MAIL_USER="rajasekhar.s@infinitylabs.in"
MAIL_SUBJECT="Daily Disk Check"
 
if [ "$CHECKDISK" -ge "$ALERT_VALUE" ]; then
echo "At least one of my disks is nearly full!" | mail -s "$MAIL_SUBJECT" $MAIL_USER
else
echo "Disk space normal" | mail -s "$MAIL_SUBJECT" $MAIL_USER
fi