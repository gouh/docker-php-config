ARG PHP_VERSION

FROM ${PHP_VERSION}

ARG TZ
ARG PROJECT_NAME
ARG UID

ENV APP_ENV=dev

## Create local user
RUN adduser -u ${UID} --disabled-password --gecos "" appuser

# Update repositories & install deps
RUN apt-get update && apt-get install -y acl libfcgi-dev libicu-dev libzip-dev libpng-dev libpcre3-dev gcc  \
    make autoconf file gettext git libfontconfig1 libxrender1 wget

# Install PHP extensions
RUN pecl install apcu timezonedb xdebug-3.3.0
RUN docker-php-ext-enable apcu timezonedb
RUN docker-php-ext-install gd intl opcache zip
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# Install composer
COPY --from=composer:2.1.14 /usr/bin/composer /usr/local/bin/composer

# Set PHP and System configurations
COPY ./app.ini /usr/local/etc/php/conf.d/app.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Set current work dir
WORKDIR /var/www/$PROJECT_NAME

CMD [ "php-fpm" ]
