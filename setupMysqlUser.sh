#!/usr/bin/env bash

function waitForMysql {
    while [[ $(mysqladmin ping --silent) != "mysqld is alive" ]]; do
        printf .
        lf=$'\n'
        sleep 1
    done
    printf "$lf"
}

# Add user for mariaDB at startup
if [ "$MYSQL_USER" ]; then
    if [ -e ~/mysql_user_added ]; then
        echo "User already added."
    else
        echo "Adding user $MYSQL_USER "
        waitForMysql
        mysql -u root -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY 'password';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;"
        mysql -u root -e "FLUSH PRIVILEGES;" 
        mysql -u root -e "CREATE DATABASE hubzilla_dev;"       
        echo "Done."
    fi
    touch ~/mysql_user_added
fi
