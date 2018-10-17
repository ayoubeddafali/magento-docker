#!/usr/bin/env  bash

/wait-for-it.sh -t 0 db:3306

export IP=$(ip addr show eth0  | grep inet | tr -s " " | cut -d" " -f3)

echo "$IP" >> js/blank.html

sleep 2 

php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "${MAGE_LOCALE}" \
    --timezone "${MAGE_TIMEZONE}" \
    --default_currency "${MAGE_CURRENCY}" \
    --db_host "db" \
    --db_name "magento" \
    --db_user "magento" \
    --db_pass '19641995' \
    --url "http://104.248.217.0/" \
    --use_rewrites "yes" \
    --use_secure "no" \
    --secure_base_url "" \
    --skip_url_validation "yes" \
    --use_secure_admin "no" \
    --admin_frontname "admin" \
    --admin_firstname "ayoub" \
    --admin_lastname "bensalem" \
    --admin_email "ayoubensalem@gmail.com" \
    --admin_username "ayoubensalem" \
    --admin_password 'soliye12F'


exec "$@"
