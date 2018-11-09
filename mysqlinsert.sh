#!/bin/bash -x

stty -echo
printf "Enter DB Username: "
read USERNAME
stty echo
printf "\n"

stty -echo
printf "Enter DB Password: "
read PASSWORD
stty echo
printf "\n"

printf " Enter Details to Create User:"
printf "\n"

printf "Enter Username: "  
read _name
printf "\n"

printf "Enter Email: " 
read _mail
printf "\n"

printf "Enter Password: " 
read _password
printf "\n"

printf "Enter ConPassword: " 
read _conpassword
printf "\n"

mysql -u$USERNAME -p$PASSWORD CISCO_MOBILITY << EOF

INSERT INTO registeruser (name,email,password,conpassword) VALUES ('$_name', '$_mail', '$_password', '$_conpassword');
EOF


