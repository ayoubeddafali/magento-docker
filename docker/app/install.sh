#!/usr/bin/env  bash

/wait-for-it.sh db:3306


php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "${MAGE_LOCALE}" \
    --timezone "${MAGE_TIMEZONE}" \
    --default_currency "${MAGE_CURRENCY}" \
    --db_host "db" \
    --db_name "magento" \
    --db_user "magento" \
    --db_pass '19641995' \
    --url "${MAGE_SITE_URL}" \
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