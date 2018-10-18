FROM fballiano/magento2-apache-php

ENV MAGE_LOCALE "en_US"
ENV MAGE_CURRENCY "EUR"
ENV MAGE_TIMEZONE "Africa/Casablanca"

COPY magento /var/www/html
WORKDIR /var/www/html

ADD docker/app/install.sh .
ADD docker/app/wait-for-it.sh /wait-for-it.sh

RUN chmod +x install.sh \
&& chmod +x mage \
&& chmod +x /wait-for-it.sh 

RUN curl -O https://files.magerun.net/n98-magerun.phar \
&& chmod +x ./n98-magerun.phar  \
&& mv n98-magerun.phar /usr/local/bin/  \
&& ./mage mage-setup . \
&& chmod -R 777 . 

VOLUME /var/www/html

ENTRYPOINT [ "./install.sh" ]

CMD ["/start.sh"]
