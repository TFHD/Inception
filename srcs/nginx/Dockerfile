FROM debian:bullseye

RUN mkdir -p /etc/nginx/ssl
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl
RUN apt-get install vim -y
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Angouleme/O=42/OU=42/CN=sabartho.42.fr/UID=sabartho"

RUN mkdir -p /var/run/nginx
COPY ./nginx/conf/default /etc/nginx/sites-available/default

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g" , "daemon off;"]
