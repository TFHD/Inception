FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y php-fpm php-mysql curl

COPY ./worldpress/tools/script.sh /

RUN chmod +x /script.sh

CMD ["./script.sh"]
