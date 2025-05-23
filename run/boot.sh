#!/usr/bin/env bash

# This is intended to be used inside Docker

echo ""
echo "   [boxed-php] Welcome!"
echo "   [boxed-php] PHP info..."
echo ""

php -ini

if [[ -f /pre_boot.sh ]]; then
	echo ""
	echo "   [boxed-php] /pre_boot.sh found, executing..."
	echo ""
	bash /pre_boot.sh
fi

echo ""
echo "   [boxed-php] Starting php-fpm and nginx..."
echo ""

multirun -v "/php-fpm.sh" "/nginx.sh"
