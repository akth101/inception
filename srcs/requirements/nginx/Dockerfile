FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y nginx openssl

# SSL 인증서 생성
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42/CN=seongjko.42.fr"

# nginx 설정 파일 복사
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# init 스크립트 복사 및 실행 권한 부여
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

# 443 포트 노출
EXPOSE 443

# init.sh 실행
ENTRYPOINT [ "sh", "/init.sh" ] 