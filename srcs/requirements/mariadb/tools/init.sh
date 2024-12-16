#!/bin/sh

echo "[MariaDB] Starting initialization..."
INIT_FLAG="/var/lib/mysql/initialization_done.flag"

# 이 부분 추가
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ ! -f "$INIT_FLAG" ]; then
    # service 명령어 대신 직접 실행
    mysqld --user=mysql &
    
    # 서버 시작 대기
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    mariadb -e "CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mariadb -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mariadb -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
    touch "$INIT_FLAG"
    
    # service 명령어 대신 직접 종료
    mysqladmin shutdown
fi

echo "[MariaDB] Initialization completed."
exec "$@"