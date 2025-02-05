ARG PHP_VERSION="8.4"

FROM php:${PHP_VERSION}-fpm-alpine

# install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# install dependencies
RUN apk add --no-cache \
        curl \
        curl-dev \
        icu-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        multirun \
        nginx \
        zlib-dev \
    && docker-php-ext-install \
        exif \
        gd \
        intl \
        zip

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/10-php-production-base.ini"

COPY app /app
COPY config/php/php.ini "$PHP_INI_DIR/20-php.ini"
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf

WORKDIR /app

CMD multirun -v "php-fpm -F" "nginx -g 'daemon off;'"
