#!/bin/bash

service mysql start 

echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" | mysql

sleep 2

service mysql stop

exec mysqld_safe
