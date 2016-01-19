#!/bin/sh

# Use the TZ environment variable, otherwise use UTC
PHP_TIMEZONE="UTC"
if [ -n "${TZ}" ]
then
    PHP_TIMEZONE="$TZ"
fi

find /etc/php5 -name php.ini -print0 | xargs -0 sed -i "s#;date.timezone =.*#date.timezone = $PHP_TIMEZONE#"
find /etc/php5 -name php.ini -print0 | xargs -0 sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 8M#"

if [ ! -z "$DEBUG" ]
then
    php5enmod xdebug
    sed -i 's#^display_errors = Off#display_errors = On#' /etc/php5/fpm/php.ini
fi
