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

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/conf.d/10-php-production-base.ini"

COPY app /app

# php config
COPY config/php/php.ini "/usr/local/etc/php/conf.d/20-boxed-php.ini"

# php-fpm config
COPY config/php/php-fpm.conf "/usr/local/etc/php-fpm.d/zzz-boxed-php.conf"

# nginx config
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf

# start scripts
COPY run/boot.sh /boot.sh
COPY run/php-fpm.sh /php-fpm.sh
COPY run/nginx.sh /nginx.sh

WORKDIR /app

ENTRYPOINT ["bash"]
CMD ["/boot.sh"]
