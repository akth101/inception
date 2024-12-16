FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y mariadb-server

COPY ./tools/init.sh /init.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /init.sh

#컨테이너 시작 시 무조건 실행됨
ENTRYPOINT [ "sh", "/init.sh" ]

CMD ["mysqld_safe"]
