FROM php:8.2.2-fpm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
    git \
    zip \
    curl \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libbz2-dev \
    libpq-dev \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && apt-get clean;

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN docker-php-ext-install pdo pdo_pgsql pgsql opcache bcmath bz2 intl

# RUN yes | pecl install xdebug-3.2.0 \
#     && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/local/bin/composer

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

RUN groupmod -o -g 1000 www-data && \
    usermod -o -u 1000 -g www-data www-data
RUN chown -R www-data:www-data /var/www

# RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
#     sed -i -e "s/^ *memory_limit.*/memory_limit = -1/g" /usr/local/etc/php/php.ini

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
