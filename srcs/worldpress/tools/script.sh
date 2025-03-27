#!/bin/sh
sleep 30

mkdir -p /var/www/html
cd /var/www/html
rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root

chmod 777 /var/www
chmod 777 /var/www/html

sed -i -r "s/database_name_here/$db_name/1"   wp-config-sample.php
sed -i -r "s/username_here/$db_user/1"  wp-config-sample.php
sed -i -r "s/password_here/$db_pwd/1"    wp-config-sample.php
sed -i -r "s/localhost/mariadb/1"    wp-config-sample.php

mv wp-config-sample.php wp-config.php
wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
wp option update siteurl "$DOMAIN_NAME" --allow-root
wp option update home "$DOMAIN_NAME" --allow-root

sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

mkdir /run/php

/usr/sbin/php-fpm7.4 -F
