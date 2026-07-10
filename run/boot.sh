#!/usr/bin/env bash

set -Eeuo pipefail

echo ""
echo "    [boxed-php] Welcome!"
echo "    [boxed-php] PHP $(php -r 'echo PHP_VERSION;')"
echo ""

if [[ -f /config-gen.sh ]]; then
    echo ""
    echo "    [boxed-php] /config-gen.sh found, executing..."
    echo ""
    /config-gen.sh
fi

if [[ -f /pre_boot.sh ]]; then
    echo ""
    echo "    [boxed-php] /pre_boot.sh found, executing..."
    echo ""
    bash /pre_boot.sh
    echo ""
fi

echo "    [boxed-php] Validating configuration..."
php-fpm -t
nginx -t

echo ""
echo "   [boxed-php] Starting php-fpm and nginx..."
echo ""

exec multirun -v "/php-fpm.sh" "/nginx.sh"
