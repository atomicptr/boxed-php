#!/usr/bin/env bash

set -Eeuo pipefail

php_env_config="/usr/local/etc/php/conf.d/30-boxed-php-env-config.ini"
nginx_env_config="/etc/nginx/boxed-php-env.conf"
php_env_config_tmp="$(mktemp "${php_env_config}.tmp.XXXXXX")"
nginx_env_config_tmp="$(mktemp "${nginx_env_config}.tmp.XXXXXX")"

cleanup() {
    rm -f "$php_env_config_tmp" "$nginx_env_config_tmp"
}

trap cleanup EXIT

fail() {
    echo "    [boxed-php] ERROR: $*" >&2
    exit 1
}

validate_integer() {
    local name="$1"
    local value="$2"
    local allow_negative_one="${3:-false}"

    if [[ "$allow_negative_one" == "true" && "$value" == "-1" ]]; then
        return
    fi

    [[ "$value" =~ ^[0-9]+$ ]] || fail "$name must be a non-negative integer"
}

validate_size() {
    local name="$1"
    local value="$2"
    local allow_unlimited="${3:-false}"

    if [[ "$allow_unlimited" == "true" && "$value" == "-1" ]]; then
        return
    fi

    [[ "$value" =~ ^[0-9]+[KMGkmg]?$ ]] || fail "$name must be a byte count with an optional K, M, or G suffix"
}

append_php_setting() {
    local setting="$1"
    local value="$2"

    printf '%s = %s\n' "$setting" "$value" >>"$php_env_config_tmp"
}

if [[ -n "${TZ+x}" ]]; then
    php -r '$timezone = $argv[1]; exit(in_array($timezone, timezone_identifiers_list(), true) ? 0 : 1);' -- "$TZ" ||
        fail "TZ is not a recognized PHP timezone"
    echo "    [boxed-php] ENV TZ found: $TZ -> PHP Setting: date.timezone"
    printf 'date.timezone = "%s"\n' "$TZ" >>"$php_env_config_tmp"
fi

if [[ -n "${PHP_MAX_EXECUTION_TIME+x}" ]]; then
    validate_integer "PHP_MAX_EXECUTION_TIME" "$PHP_MAX_EXECUTION_TIME"
    echo "    [boxed-php] ENV PHP_MAX_EXECUTION_TIME found: $PHP_MAX_EXECUTION_TIME -> PHP Setting: max_execution_time"
    append_php_setting "max_execution_time" "$PHP_MAX_EXECUTION_TIME"
fi

if [[ -n "${PHP_MAX_INPUT_TIME+x}" ]]; then
    validate_integer "PHP_MAX_INPUT_TIME" "$PHP_MAX_INPUT_TIME" true
    echo "    [boxed-php] ENV PHP_MAX_INPUT_TIME found: $PHP_MAX_INPUT_TIME -> PHP Setting: max_input_time"
    append_php_setting "max_input_time" "$PHP_MAX_INPUT_TIME"
fi

if [[ -n "${PHP_MEMORY_LIMIT+x}" ]]; then
    validate_size "PHP_MEMORY_LIMIT" "$PHP_MEMORY_LIMIT" true
    echo "    [boxed-php] ENV PHP_MEMORY_LIMIT found: $PHP_MEMORY_LIMIT -> PHP Setting: memory_limit"
    append_php_setting "memory_limit" "$PHP_MEMORY_LIMIT"
fi

if [[ -n "${PHP_UPLOAD_MAX_FILESIZE+x}" ]]; then
    validate_size "PHP_UPLOAD_MAX_FILESIZE" "$PHP_UPLOAD_MAX_FILESIZE"
    echo "    [boxed-php] ENV PHP_UPLOAD_MAX_FILESIZE found: $PHP_UPLOAD_MAX_FILESIZE -> PHP Setting: upload_max_filesize"
    append_php_setting "upload_max_filesize" "$PHP_UPLOAD_MAX_FILESIZE"
fi

if [[ -n "${PHP_POST_MAX_SIZE+x}" ]]; then
    validate_size "PHP_POST_MAX_SIZE" "$PHP_POST_MAX_SIZE"
    echo "    [boxed-php] ENV PHP_POST_MAX_SIZE found: $PHP_POST_MAX_SIZE -> PHP Setting: post_max_size"
    append_php_setting "post_max_size" "$PHP_POST_MAX_SIZE"
fi

if [[ -n "${PHP_POST_MAX_SIZE+x}" ]]; then
    echo "    [boxed-php] ENV PHP_POST_MAX_SIZE found: $PHP_POST_MAX_SIZE -> NGINX Setting: client_max_body_size"
    printf 'client_max_body_size %s;\n' "${PHP_POST_MAX_SIZE,,}" >"$nginx_env_config_tmp"
elif [[ -n "${PHP_UPLOAD_MAX_FILESIZE+x}" ]]; then
    echo "    [boxed-php] ENV PHP_UPLOAD_MAX_FILESIZE found: $PHP_UPLOAD_MAX_FILESIZE -> NGINX Setting: client_max_body_size"
    printf 'client_max_body_size %s;\n' "${PHP_UPLOAD_MAX_FILESIZE,,}" >"$nginx_env_config_tmp"
else
    printf 'client_max_body_size 10m;\n' >"$nginx_env_config_tmp"
fi

chmod 0644 "$php_env_config_tmp" "$nginx_env_config_tmp"
mv -f "$php_env_config_tmp" "$php_env_config"
mv -f "$nginx_env_config_tmp" "$nginx_env_config"
