#!/bin/sh

echo "[NGINX] Starting initialization..."

# NGINX 설정 테스트
nginx -t

# NGINX 포그라운드 모드로 시작
nginx -g 'daemon off;'

echo "[NGINX] Initialization completed."
