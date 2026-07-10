#!/usr/bin/env bash

set -Eeuo pipefail

umask 002
exec php-fpm -F
