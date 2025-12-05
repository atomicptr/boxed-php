#!/usr/bin/env bash

php_env_config="/usr/local/etc/php/conf.d/30-boxed-php-env-config.ini"

if [[ -n "${TZ+x}" ]]; then
    echo "    [boxed-php] ENV TZ found: $TZ -> PHP Setting: date.timezone"
    echo "date.timezone = $TZ" >>"$php_env_config"
fi

if [[ -n "${PHP_MAX_EXECUTION_TIME+x}" ]]; then
    echo "    [boxed-php] ENV PHP_MAX_EXECUTION_TIME found: $PHP_MAX_EXECUTION_TIME -> PHP Setting: max_execution_time"
    echo "max_execution_time = $PHP_MAX_EXECUTION_TIME" >>"$php_env_config"
fi

if [[ -n "${PHP_MAX_INPUT_TIME+x}" ]]; then
    echo "    [boxed-php] ENV PHP_MAX_INPUT_TIME found: $PHP_MAX_INPUT_TIME -> PHP Setting: max_input_time"
    echo "max_input_time = $PHP_MAX_INPUT_TIME" >>"$php_env_config"
fi

if [[ -n "${PHP_MEMORY_LIMIT+x}" ]]; then
    echo "    [boxed-php] ENV PHP_MEMORY_LIMIT found: $PHP_MEMORY_LIMIT -> PHP Setting: memory_limit"
    echo "memory_limit = $PHP_MEMORY_LIMIT" >>"$php_env_config"
fi

if [[ -n "${PHP_UPLOAD_MAX_FILESIZE+x}" ]]; then
    echo "    [boxed-php] ENV PHP_UPLOAD_MAX_FILESIZE found: $PHP_UPLOAD_MAX_FILESIZE -> PHP Setting: upload_max_filesize"
    echo "upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE" >>"$php_env_config"
    echo "    [boxed-php] ENV PHP_UPLOAD_MAX_FILESIZE found: $PHP_UPLOAD_MAX_FILESIZE -> NGINX Setting: client_max_body_size"
    sed -i "s/client_max_body_size 10M/client_max_body_size ${PHP_UPLOAD_MAX_FILESIZE}/" /etc/nginx/http.d/default.conf
fi
