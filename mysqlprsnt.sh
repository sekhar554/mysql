#! /bin/bash
# Check Whether Mysql is Present or Not.

type mysql >/dev/null 2>&1 && echo "MySQL present." || echo "MySQL not present."

# Check this also if you want
#if [ -f /usr/sbin/mysqld ]; then
#    echo "MySQL Installed"
#else
#    echo "MySQL not Installed"
#fi

# Check this also if you want
#if [ -f /etc/init.d/mysql* ]; then
#    echo "MySQL Installed"
#else
#    echo "MySQL not Installed"
#fi
