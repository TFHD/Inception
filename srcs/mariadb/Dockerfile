FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server mariadb-client

RUN sed -i 's/127.0.0.1/0.0.0.0/1' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./mariadb/tools/script.sh /

RUN chmod +x /script.sh

CMD ["./script.sh"]
