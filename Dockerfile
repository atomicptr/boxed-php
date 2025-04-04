ARG PHP_VERSION="8.4"

FROM php:${PHP_VERSION}-fpm-alpine

# install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# install dependencies
RUN apk add --no-cache \
        curl \
        curl-dev \
        bash \
        icu-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        multirun \
        nginx \
        npm \
        zlib-dev \
    && docker-php-ext-install \
        bcmath \
        exif \
        gd \
        intl \
        opcache \
        zip

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/10-php-production-base.ini"

COPY app /app
COPY config/php/php.ini "$PHP_INI_DIR/20-php.ini"
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf
COPY run/boot.sh /boot.sh
COPY run/php-fpm.sh /php-fpm.sh
COPY run/nginx.sh /nginx.sh

WORKDIR /app

ENTRYPOINT ["bash"]
CMD ["/boot.sh"]
