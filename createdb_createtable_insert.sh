#!/bin/bash

#script that ask for user's name, surname  dob and age

echo "Enter your name"
read name

echo "Enter your surname"
read surname

echo "Enter your dob"
read dob

echo "Enter your age"
read age

age()

{
    age="dob -1901"
}

mysql -hlocalhost -uroot -proot123 -e "create database sekhar;"
#mysql -hlocalhost -uroot -proot123 -e "show databases;"
#mysql -hlocalhost -uroot -proot123 -e "use sekhar;"
mysql -hlocalhost -uroot -proot123 -Dsekhar -e "CREATE TABLE test(id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,name VARCHAR(100), surname VARCHAR(100), dob DATE, age VARCHAR (10),PRIMARY KEY (id));"
mysql -hlocalhost -uroot -proot123 -Dsekhar -e "INSERT into test(name,surname,dob,age)VALUES('$name','$surname','$dob','$age');"
