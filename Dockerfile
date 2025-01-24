ARG PHP_VERSION="8.4"

FROM php:${PHP_VERSION}-fpm-alpine

RUN apk add --no-cache multirun nginx

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/10-php-production-base.ini"

COPY app /app
COPY config/php/php.ini "$PHP_INI_DIR/20-php.ini"
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf

WORKDIR /app

CMD multirun -v "crond -f -d 6" "php-fpm -F" "nginx -g 'daemon off;'"
