


#In case the SLEEP connection on MySQL DB is too large and are not cleared automatically, 
#we can kill the connection explicitely on the database using the following command:


mysql -u<Username> -p<password> -e "show processlist;" | grep Sleep | awk '{print $1}' | while read LINE; 
do 
mysql -u<Username> -p<password> -e "kill $LINE"; 
done 