FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y \
    php-mysqli \
    php-fpm \
    mariadb-client \
    wget \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://wordpress.org/latest.tar.gz \
    && tar -zxvf latest.tar.gz \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./conf/php.ini /etc/php/7.4/fpm/php.ini
COPY ./tools/init.sh init.sh

RUN chmod +x init.sh

ENTRYPOINT [ "sh", "/init.sh" ]
CMD ["php-fpm7.4", "-F"]