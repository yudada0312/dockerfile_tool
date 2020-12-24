FROM php:7.2.14-alpine3.9
LABEL maintainer="yudada <yudada0312@gmail.com>"
RUN apk update && apk upgrade && apk add bash git openssh && apk add zlib-dev \
#apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.9/community/ php7=7.2.22-r0 \
 && apk add composer && apk add nodejs npm && apk add tig && rm /var/cache/apk/*

RUN apk add zsh && apk add zsh-vcs \
 && cd /root \
 && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
 && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
 && git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

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
RUN docker-php-ext-install bcmath
RUN apk add libxml2-dev && docker-php-ext-install soap

ENV WORKDIR /var/www/html
ENV TMPDIR /var/tmp

COPY entrypoint.sh ${TMPDIR}

RUN mkdir /root/mobile

WORKDIR ${WORKDIR}
# for mobile dev
EXPOSE 8000
CMD ["/bin/sh", "-c","tail -f /dev/null"]