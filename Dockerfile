FROM php:7.2.14-alpine3.8
LABEL maintainer="yudada <yudada0312@gmail.com>"
RUN apk update && apk upgrade && apk add bash git openssh && apk add zlib-dev \
#apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.9/community/ php7=7.2.22-r0 \
 && apk add composer && apk add nodejs npm && rm /var/cache/apk/*

#Install PHP extensions
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql

ENV WORKDIR /var/www/html
ENV TMPDIR /var/tmp
ENV ROOTDIR /root

RUN cd ${ROOTDIR} && mkdir .ssh &&  cd ${TMPDIR} && mkdir db
COPY .ssh ${ROOTDIR}/.ssh

WORKDIR ${WORKDIR}

CMD ["/bin/sh", "-c","tail -f /dev/null"]