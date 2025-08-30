FROM debian:bookworm

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apache2

RUN sed -i  's/80/81/g' /etc/apache2/ports.conf

COPY ./html /var/www/html

CMD ["apachectl", "-D", "FOREGROUND"]
