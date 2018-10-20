#!/usr/bin/env  bash

/wait-for-it.sh -t 0 master:3306

export IP=$(ip addr show eth0  | grep inet | tr -s " " | cut -d" " -f3)
echo "$IP" >> js/blank.html
sleep 2 

/wait-for-it.sh redis:6379
/wait-for-it.sh -q -t 5 apache:80


if [ $? -ne 0 ]
then
php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "${MAGE_LOCALE}" \
    --timezone "${MAGE_TIMEZONE}" \
    --default_currency "${MAGE_CURRENCY}" \
    --db_host "master" \
    --db_name "magento" \
    --db_user "magento" \
    --db_pass '19641995' \
    --url "http://ayoubensalem.com/" \
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
    --admin_password 'soliye12F' \
    --session_save  "db"

sed -i "/<global>/ a\\
 <session_save>db</session_save> \\
	<redis_session> \\
	<host>redis</host> \\
	<port>6379</port> \\
	<password></password> \\
	<timeout>10</timeout> \\
	<persistent></persistent> \\
	<db>1</db> \\
	<compression_threshold>2048</compression_threshold> \\
	<compression_lib>lzf</compression_lib> \\
	<log_level>1</log_level> \\
	<max_concurrency>64</max_concurrency> \\
	<break_after_frontend>5</break_after_frontend> \\
	<break_after_adminhtml>30</break_after_adminhtml> \\
	<first_lifetime>600</first_lifetime> \\
	<bot_first_lifetime>60</bot_first_lifetime> \\
	<bot_lifetime>7200</bot_lifetime> \\
	<disable_locking>0</disable_locking> \\
	<min_lifetime>86400</min_lifetime> \\
	<max_lifetime>2592000</max_lifetime> \\
    </redis_session> \\
    <cache> \\
        <backend>Cm_Cache_Backend_Redis</backend> \\
        <backend_options> \\
          <default_priority>10</default_priority> \\
          <auto_refresh_fast_cache>1</auto_refresh_fast_cache> \\
            <server>redis-cache</server> \\
            <port>6379</port> \\
            <persistent></persistent> \\
            <database>1</database> \\
            <password></password> \\
            <force_standalone>0</force_standalone> \\
            <connect_retries>1</connect_retries> \\
            <read_timeout>10</read_timeout> \\
            <automatic_cleaning_factor>0</automatic_cleaning_factor> \\
            <compress_data>1</compress_data> \\
            <compress_tags>1</compress_tags> \\
            <compress_threshold>204800</compress_threshold> \\
            <compression_lib>lzf</compression_lib> \\
        </backend_options> \\
    </cache>" /var/www/html/app/etc/local.xml
  
    sed -i "s/false/true/" /var/www/html/app/etc/modules/Cm_RedisSession.xml

fi 


exec "$@"
