#!/bin/bash

# 오류 발생 시 즉시 종료
set -euo pipefail

INIT_FLAG="/var/www/html/initialization_done.flag"
MAX_TRY=30
WP_ROOT="/var/www/html"

# PHP 및 WordPress 초기 설정
setup_wordpress() {
    mkdir -p /run/php
    chown -R www-data:www-data "$WP_ROOT"
    rm -rf /var/www/html/*
    mv wordpress/* /var/www/html
    configure_wp_config
}

# wp-config.php 설정
configure_wp_config() {
    local config_sample="$WP_ROOT/wp-config-sample.php"
    local config_file="$WP_ROOT/wp-config.php"
    
    mv "$config_sample" "$config_file"
    
    # 데이터베이스 설정 변경
    sed -i "s/database_name_here/$DB_NAME/" "$config_file"
    sed -i "s/username_here/$DB_USER/" "$config_file"
    sed -i "s/password_here/$DB_PASSWORD/" "$config_file"
    sed -i "s/localhost/$DB_HOST/" "$config_file"
}

# 데이터베이스 연결 확인
wait_for_database() {
    local try=0
    
    echo "Waiting for database connection..."
    while ! mysqladmin -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" ping; do
        try=$((try+1))
        if [ $try -eq $MAX_TRY ]; then
            echo "Failed to connect to database after $MAX_TRY attempts"
            break
        fi
        sleep 1
    done
}

# WordPress 코어 및 사용자 설정
setup_wordpress_core() {
    cd "$WP_ROOT"
    
    # WordPress 코어 설치
    wp core install \
        --url="$URL" \
        --title="$TITLE" \
        --admin_user="$ADMIN_ID" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --skip-email \
        --locale=ko_KR \
        --allow-root

    # 일반 사용자 생성
    wp user create "$USER_ID" "$USER_EMAIL" \
        --role=author \
        --user_pass="$USER_PASSWORD" \
        --allow-root

    # 보안 솔트 재생성
    wp config shuffle-salts --allow-root
}

# 메인 실행 함수
main() {
    if [ ! -f "$INIT_FLAG" ]; then
        echo "Starting WordPress initialization..."
        setup_wordpress
        wait_for_database
        sleep 5  # 추가 안정성을 위한 대기
        wait_for_database  # 한번 더 확인
        setup_wordpress_core
        touch "$INIT_FLAG"
        echo "WordPress initialization completed"
    else
        echo "WordPress already initialized"
    fi
}

# 스크립트 실행
main
exec "$@"