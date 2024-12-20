FROM debian:bullseye

RUN apt-get update -y \
    && apt-get install -y nginx openssl


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42/CN=seongjko.42.fr"


COPY ./conf/default.conf /etc/nginx/conf.d/default.conf


COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT [ "sh", "/init.sh" ]
CMD ["nginx", "-g", "daemon off;"]