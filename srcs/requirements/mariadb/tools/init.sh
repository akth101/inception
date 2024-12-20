
#!/bin/sh

echo "[MariaDB] Starting initialization..."
INIT_FLAG="/var/lib/mysql/initialization_done.flag"

if [ ! -f "$INIT_FLAG" ]; then
    service mariadb start
    mariadb -e "CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mariadb -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mariadb -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
    mariadb -e "ALTER USER root@localhost IDENTIFIED VIA mysql_native_password USING PASSWORD('${ROOT_PASSWORD}');" 
    mariadb -e "FLUSH PRIVILEGES;"
    touch "$INIT_FLAG"
    service mariadb stop
fi

echo "[MariaDB] Initialization completed."
exec "$@"

