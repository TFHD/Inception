FROM debian:bullseye

RUN mkdir -p /etc/nginx/ssl
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl
RUN apt-get install vim -y
RUN openssl req -x509 -nodes -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=IDF/L=Angouleme/O=42/OU=42/CN=sabartho.42.fr/UID=sabartho"

RUN mkdir -p /var/run/nginx
COPY ./nginx/conf/default /etc/nginx/sites-available/default

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html
EXPOSE 443
CMD ["nginx", "-g" , "daemon off;"]
