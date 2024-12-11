
#!/bin/sh

echo "[MariaDB] Starting initialization..."

# 임시로 MariaDB 서비스 시작(DB 초기화 작업을 위해) 추가 프로세스로 생성됨 
service mariadb start

# WordPress용 DB 생성
mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

# WordPress 유저 생성 (관리자)
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"

# 일반 유저 생성
mariadb -e "CREATE USER IF NOT EXISTS '${WP_USER}'@'%' IDENTIFIED BY '${WP_USER_PASSWORD}';"
mariadb -e "GRANT SELECT, INSERT, UPDATE, DELETE ON ${DB_NAME}.* TO '${WP_USER}'@'%';"

# root 비밀번호 설정
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# 변경사항 적용
mariadb -e "FLUSH PRIVILEGES;"

# 임시로 실행했던 mariadb 서비스 종료
service mariadb stop

# MariaDB 서버를 PID 1으로 실행
exec mysqld
# 이 명령어로 container의 pid1(첫 번째 프로세스)이 sh 대신 mysqld가 되도록 대체해버림
# mysqld는 자체적으로 데몬으로 동작하며 백그라운드에서 계속 실행됨.
# 그렇기 때문에 별도의 무한 루프 없이도 계속 실행됨.

echo "[MariaDB] Initialization completed."
