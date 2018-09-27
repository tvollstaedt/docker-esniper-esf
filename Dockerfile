FROM php:5-apache
MAINTAINER Thomas Vollstädt <tv@engage.de>

RUN apt-get update && \
    apt-get install -y curl git libfreetype6-dev libjpeg62-turbo-dev libpng-dev libcurl4-gnutls-dev build-essential automake && \
    apt-get autoclean

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd

RUN git clone https://github.com/syssi/es-f.git && \
    cd es-f && \
    sed -i "s#git://yryie.git.sourceforge.net/gitroot/yryie/yryie#git://git.code.sf.net/p/yryie/code#g" .gitmodules && \
    sed -i "s#git://yuelo.git.sourceforge.net/gitroot/yuelo/yuelo#git://git.code.sf.net/p/yuelo/code#g" .gitmodules && \
    git submodule init && \
    git submodule update && \
    cp -a * /var/www/html/ && \
    cd && \
    git clone git://git.code.sf.net/p/esniper/git esniper-git && \
    cd esniper-git && \
    sed -i "s/am__api_version='1\.14'/am__api_version='1\.15'/g" configure && \
    ./configure && \
    aclocal && \
    make && \
    make install && \
    chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html"]
