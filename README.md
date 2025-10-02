# boxed-php

Convenient PHP base container

## Features

- PHP-FPM and nginx in one container
- Runs Laravel and Symfony applications out of the box
- Supports PHP versions 8.2, 8.3 and 8.4
- Updated daily
- Configurate vital settings via ENV vars

## Usage

This is intended to be used as a base image, so in your Dockerfile do:

```docker
FROM ghcr.io/atomicptr/boxed-php:8.4

# add some packages
RUN apk add --no-cache bash

# install some php extension...
RUN docker-php-ext-install gd

# assuming that we are in your root dir with a public/
COPY . /app
```

## Configuration (via ENV vars)

- **TZ**: Sets PHP `date.timezone` for consistent date handling (e.g., "UTC" or "America/New_York").
- **PHP_MAX_EXECUTION_TIME**: Sets PHP `max_execution_time` to limit script runtime in seconds (default: 30; 0 for unlimited).
- **PHP_MAX_INPUT_TIME**: Sets PHP `max_input_time` to limit input parsing time in seconds (default: 60; affects uploads).
- **PHP_MEMORY_LIMIT**: Sets PHP `memory_limit` for maximum script memory usage (default: 128M; e.g., "256M").
- **PHP_UPLOAD_MAX_FILESIZE**: Sets PHP `upload_max_filesize` for maximum uploaded file size (default: 2M; e.g., "10M").

## License

BSD 0-clause
