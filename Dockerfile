FROM php:5.6-apache

RUN apt-get update && apt-get install -y libmcrypt-dev libxml2-dev libzip-dev

RUN docker-php-ext-install \
    bcmath \
    gettext \
    mcrypt \
    mysql \
    mysqli \
    pdo_mysql \
    pcntl \
    soap \
    sockets \
    xmlrpc \
    zip \
    opcache