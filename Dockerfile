ARG PHP_VERSION="8.5"

FROM php:${PHP_VERSION}-fpm-alpine

# install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# install dependencies
RUN apk add --no-cache \
        bash \
        curl \
        curl-dev \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        libzip-dev \
        multirun \
        nginx \
        npm \
        zlib-dev

RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install gd

# Install opcache only on PHP <8.5 (default since 8.5)
RUN if php -r "exit(version_compare(PHP_VERSION, '8.5.0', '<') ? 0 : 1);"; then \
        docker-php-ext-install opcache; \
    fi

RUN docker-php-ext-install \
    bcmath \
    exif \
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
COPY run/config-gen.sh /config-gen.sh
COPY run/php-fpm.sh /php-fpm.sh
COPY run/nginx.sh /nginx.sh

WORKDIR /app

ENTRYPOINT ["bash"]
CMD ["/boot.sh"]
