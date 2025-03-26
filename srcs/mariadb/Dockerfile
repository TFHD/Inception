FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server mariadb-client zsh gettext-base

EXPOSE 3306

COPY ./mariadb/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir /entrypoint-initdb.d/

COPY ./mariadb/init.sql.template /entrypoint-initdb/.

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
COPY ./mariadb/docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mysqld"]
