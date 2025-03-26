FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl php-fpm php-mysqli zsh
RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY ./worldpress/conf/www.conf /etc/php/7.4/fpm/pool.d/
WORKDIR /var/www/html/
COPY ./worldpress/tools/script.sh ./

EXPOSE 9000
ENTRYPOINT ["/var/www/html/script.sh"]

CMD ["php-fpm7.4", "-F"]
