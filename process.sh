#!/bin/sh

ps aux --sort=-%cpu | awk 'NR==1{print $2,$3,$11}NR>1{if($3!=0.0) print $2,$3,$11}' > some_file.txt

cat some_file.txt | mail -s "Process CPU details" sekhar.mysql2016@gmail.com

