#!/bin/bash

echo "Launching WordPress install"

if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || \
	[ -z "$SQL_PASSWORD" ] || [ -z "$DOMAIN_NAME" ] || \
	[ -z "$WP_ADMIN_USER" ] || [ -z "$WP_ADMIN_PASSWORD" ] || \
	[ -z "$WP_ADMIN_EMAIL" ] || [ -z "$WP_USER" ] || \
	[ -z "$WP_USER_EMAIL" ] || [ -z "$WP_USER_PASSWORD" ]; then
    echo "Missing env variables"
    exit 1
fi

echo "Connecting to the data base"
sleep 10


MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
		if mysqladmin ping -h"mariadb" -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; then
				echo "Connection succesfull"
				break
		fi
		echo "Waiting for MariaDB. attempts : $((COUNT + 1))/$MAX_RETRIES"
		sleep 2
		COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
		echo "Failed connection after $MAX_RETRIES attempts."
		exit 1
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress"
    wp core download --version=6.0 --locale=fr_FR --allow-root

    echo "Creation wp-config.php file"
    wp config create --allow-root \
        --dbname="${SQL_DATABASE}" \
        --dbuser="${SQL_USER}" \
        --dbpass="${SQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --path="/var/www/html/"

    echo "Core install"
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Deception" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="/var/www/html/"

    echo "Creating user ${WP_USER}"
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root \
        --path="/var/www/html/"
else
    echo "WordPress is already installed. No changes"
fi

mkdir -p /run/php

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM"
sleep 2
exec php-fpm7.4 -F