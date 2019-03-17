FROM php:7.1-apache

MAINTAINER Ayoub Ed-dafali <ayoubensalem@gmail.com>

ENV MAGE_LOCALE "en_US"
ENV MAGE_CURRENCY "EUR"
ENV MAGE_TIMEZONE "Africa/Casablanca"

RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    git \
    vim \
    wget \
    lynx \
    psmisc \
  && apt-get clean

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    opcache \
    bcmath \
    soap


RUN printf "\n" |  pecl install -o  -a -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

ADD https://raw.githubusercontent.com/colinmollenhour/credis/master/Client.php /credis.php
ADD php.ini /usr/local/etc/php/conf.d/888-ayoubensalem.ini
ADD register-host-on-redis.php /register-host-on-redis.php
ADD unregister-host-on-redis.php /unregister-host-on-redis.php
ADD start.sh /start.sh

RUN usermod -u 1000 www-data; \
  a2enmod rewrite; \
  curl -o /tmp/composer-setup.php https://getcomposer.org/installer; \
  curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig; \
  php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"; \
  php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer; \
	rm /tmp/composer-setup.php; \
  chmod +x /usr/local/bin/composer; \
  chmod +x /start.sh; \
  chmod +r /credis.php; \
  mkdir -p /root/.composer



#COPY magento /var/www/html
WORKDIR /var/www/html

ADD install.sh /install.sh
ADD wait-for-it.sh /wait-for-it.sh

RUN chmod +x /install.sh \
&& chmod +x /wait-for-it.sh 

VOLUME /var/www/html

ENTRYPOINT [ "/install.sh" ]

CMD ["/start.sh"]
