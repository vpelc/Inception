FROM debian::bullseye

RUN apt-get update && apt-get install nginx -y
RUN apt-get install openssl -y
RUN rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/sites-available/default

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/setup_ssl.sh
RUN chmod +x /setup.sh

RUN chmod -R 755 /var/www/html

RUN chmod -R www-data:www-data /var/www/html

EXPOSE 443

ENTRYPOINT ["bash", "/setup.sh"]