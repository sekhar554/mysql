stty -echo
printf "Username: "
read USERNAME
stty echo
printf "\n"


stty -echo
printf "Password: "
read PASSWORD
stty echo
printf "\n"

mysql -u$USERNAME -p$PASSWORD
