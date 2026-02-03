#!/bin/bash


if  [ -z "$DOMAIN_NAME" ]; then
	echo "env var DOMAIN_NAME is missing."
	exit 1
fi

mkdir -p /etc/nginx/ssl

if [! -f /etc/nginx/ssl/nginx.crt ]; then
	echo "Generating self-signed SSL certification"

	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \ 
		-subj "/C=BE/ST=Brussels/L=Brussels/O=42School/OU=student/CN=${DOMAIN_NAME}"

	echo "Generation succesfull"

else
	echo "No generation, certificate already exist."

fi

echo "Starting NGINX"

exec ngninx -g "daemon off;"