FROM php:7.2.14-fpm-alpine3.8
LABEL maintainer="yudada <yudada0312@gmail.com>"

ENV TIME_ZONE Asia/Shanghai

RUN apk update && apk upgrade && apk add bash git && apk add --no-cache tzdata && echo "${TIME_ZONE}" > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# Install PHP extensions
RUN docker-php-ext-install sockets && docker-php-ext-install pdo_mysql && docker-php-ext-install bcmath

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv composer.phar /usr/local/bin/composer