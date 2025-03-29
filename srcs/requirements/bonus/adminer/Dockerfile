FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y php-fpm php-mysql wget

RUN mkdir -p /var/www/html /run/php

RUN wget -O /var/www/html/adminer.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 8080

CMD ["php-fpm7.4", "-F"]
