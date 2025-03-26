#!/bin/sh

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$WORDPRESS_DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASS --dbhost=$WORDPRESS_DB_HOST --allow-root
./wp-cli.phar core install --url=sabartho.42.fr --title=inception --admin_user=$WORDPRESS_DB_USER --admin_password=$WORDPRESS_DB_PASSWORD --admin_email=admin@admin.com --allow-root
exec "$@"
