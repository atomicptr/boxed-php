#!/usr/bin/env bash

php_env_config="/usr/local/etc/php/conf.d/30-boxed-php-env-config.ini"

if [[ -n "${TZ+x}" ]]; then
    echo "    [boxed-php] ENV TZ found: $TZ -> PHP Setting: date.timezone"
    echo "date.timezone = $TZ" >>"$php_env_config"
fi
