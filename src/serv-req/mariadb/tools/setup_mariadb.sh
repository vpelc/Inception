#!/bin/bash

echo "Lauching MariaDB init"

if [ -z "$SQL_ROOT_PASSWORD" ] || [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ]; then
    echo "Missing env variables"
    exit 1
fi

service mariadb start

echo "Connecting to the data base"

MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
		if mysqladmin ping -h"localhost" --silent; then
				echo "Connection succesfull"
				break
		fi
		echo "Waiting for MariaDB to start... Attempts $((COUNT + 1))/$MAX_RETRIES"
		sleep 2
		COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
		echo "Connection failed after $MAX_RETRIES attempts."
		exit 1
fi

echo "MariaDB is ready. Creating data base and users"

mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysql -u root -p"${SQL_ROOT_PASSWORD}" << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Data base configuration succesfull"

# Arrêt de MariaDB pour un redémarrage en mode production
echo "Starting MariaDB"
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

sleep 2

# Démarrer MariaDB en avant-plan (foreground)
exec mysqld_safe