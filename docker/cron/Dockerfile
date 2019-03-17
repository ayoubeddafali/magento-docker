FROM ayoubensalem/magento1-app:test
MAINTAINER Ayoub Ed-dafali <ayoubensalem@gmail.com>

ADD crontab /crontab.www-data
ADD start.sh /start.sh
#ADD https://raw.githubusercontent.com/nexcess/magento-turpentine/master/app/code/community/Nexcessnet/Turpentine/Model/Varnish/Admin/Socket.php /varnish.php
ADD varnish.php /varnish.php
ADD updatenodes.php /updatenodes.php
ADD varnish.secret /varnish.secret

RUN apt-get update && apt-get install -y cron rsyslog && apt-get clean
RUN crontab -u www-data /crontab.www-data; \
  chmod +x /start.sh; \
  chmod +r /varnish.php; \
  touch /var/log/syslog; \
  touch /var/log/cron.log; \
  rm /register-host-on-redis.php; \
  rm /unregister-host-on-redis.php;


ENTRYPOINT [""]

CMD "/start.sh"
