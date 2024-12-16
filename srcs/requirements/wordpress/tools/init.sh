#!/bin/bash

INIT_FLAG="/var/www/html/initialization_done.flag"

# if [ ! -f "$INIT_FLAG" ]; then
    echo "[WordPress] Starting initialization..."
    mkdir -p /run/php
    chown www-data:www-data /run/php
    chown -R www-data:www-data /var/www/html
    cp -r wordpress/* /var/www/html
    rm -rf wordpress
    mv /var/www/html/wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$DB_NAME/" wp-config.php
    sed -i "s/username_here/$DB_USER/" wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
    sed -i "s/localhost/$DB_HOST/" wp-config.php
    mv wp-config.php /var/www/html
    MAX_TRY=10
    TRY=0
    while ! mysqladmin -h $DB_HOST -u $DB_USER -p$DB_PASSWORD ping ; do
        TRY=$((TRY+1))
        sleep 1
        if [ $TRY -eq $MAX_TRY ]; then
            break
        fi
    done
    sleep 5
    TRY=0
    while ! mysqladmin -h $DB_HOST -u $DB_USER -p$DB_PASSWORD ping ; do
        TRY=$((TRY+1))
        sleep 1
        if [ $TRY -eq $MAX_TRY ]; then
            break
        fi
    done
    cd /var/www/html
    wp core install --url="$URL" --title="$TITLE" --admin_user="$ADMIN_ID" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --skip-email --locale=ko_KR --allow-root
    wp user create $USER_ID $USER_EMAIL --role=author --user_pass=$USER_PASSWORD --allow-root
    wp config shuffle-salts --allow-root
    touch "$INIT_FLAG"
    echo "[WordPress] initialization completed."
# fi

exec "$@"