#!/bin/bash

set -e

TARGET_DIR=/data/backup

# *sigh*
MYSQL_DB=$(php5 -r "$(grep wgDBname  /data/LocalSettings.php; echo 'print $wgDBname;';)")
MYSQL_HOST=$(php5 -r "$(grep wgDBserver /data/LocalSettings.php; echo 'print $wgDBserver;';)")
MYSQL_USER=$(php5 -r "$(grep wgDBadmin /data/LocalSettings.php; echo 'print $wgDBadminuser;';)")
MYSQL_PASSWD=$(php5 -r "$(grep wgDBadmin /data/LocalSettings.php; echo 'print $wgDBadminpassword;';)")

echo "Backing up mediawiki database…"

FILENAME=wiki-$(date '+%Y%m%d').sql
TARGET_FILE=$TARGET_DIR/$FILENAME
nice -n19 mysqldump -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASSWD $MYSQL_DB --opt -c > $TARGET_FILE
md5sum $TARGET_FILE > $TARGET_FILE.md5sum
chmod 600 $TARGET_DIR/*.sql
