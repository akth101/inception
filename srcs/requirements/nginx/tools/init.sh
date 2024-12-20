#!/bin/sh

echo "[NGINX] Starting initialization..."

MAX_TRY=30
TRY=0

# WordPress 초기화 완료 대기
while [ $TRY -lt $MAX_TRY ]; do
    if [ -f /var/www/html/initialization_done.flag ]; then
        echo "[NGINX] WordPress initialization detected."
        break
    fi
    echo "[NGINX] Waiting for WordPress initialization... ($TRY/$MAX_TRY)"
    TRY=$((TRY+1))
    sleep 1
done

if [ $TRY -eq $MAX_TRY ]; then
    echo "[NGINX] Timeout waiting for WordPress initialization"
    exit 1
fi

# NGINX 시작

echo "[NGINX] initialization completed."
exec "$@"