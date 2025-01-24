# boxed-php

PHP application base container using NGINX with PHP-FPM

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
