#! /bin/bash

Disk=$(df -h| grep 'Filesystem\|/dev/sda*')
Memory=$(free -h | grep -v +)
MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

LoadAvg=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
Uptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)

echo "Disk Usage:-"
echo "$Disk"
echo "Mem & Swap Usage:- It appears $MEM% of RAM used."
echo "$Memory"
echo "Load Average = $LoadAvg"
echo "System Uptime Days/(HH:MM) = $Uptime"

