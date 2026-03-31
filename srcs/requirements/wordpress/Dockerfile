FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    && apt-get clean

RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000
CMD ["/setup.sh"]
