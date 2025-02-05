# boxed-php

Convenient PHP base container

## Features

- PHP-FPM and nginx in one container
- Runs Laravel and Symfony applications out of the box
- Supports PHP versions 8.2, 8.3 and 8.4
- Updated daily

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

## License

BSD 0-clause
