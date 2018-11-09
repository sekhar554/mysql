user=root
pass=root123


a=$(mysql -u$user -p$pass -e "SHOW GLOBAL STATUS" | grep 'Key_reads' | awk '{ print $2 }')
b=$(mysql -u$user -p$pass -e "SHOW GLOBAL STATUS" | grep "Key_read_requests" | awk '{ print $2 }')
A=$(mysql -u$user -p$pass -e "SHOW GLOBAL STATUS" | grep 'Open_files' | awk '{ print $2 }')
B=$(mysql -u$user -p$pass -e "SHOW GLOBAL STATUS" | grep 'Opened_files' | awk '{ print $2 }')


echo "scale=3; (1.0 - ($A / $B)) * 100" | bc -l > /tmp/ratio.txt
echo "scale=3; (1.0 - ($a / $b)) * 100" | bc -l >> /tmp/ratio.txt

cat /tmp/ratio.txt | mail -s "KeyHitRatio & OpenHitRatio" sekhar.mysql2016@gmail.com
