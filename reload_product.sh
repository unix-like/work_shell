#!/bin/bash

#BASE_DIR=`dirname $0`

#source ${BASE_DIR}/.cron_env
source ~/.cron_env

SRC_DB="db_go2"
DST_DB="db_stats"

MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"

TABS="product"

function refresh_tab_data()
{
$MYSQLDUMP -u$GO2_STAGE_USER -p$GO2_STAGE_PWD  -h$GO2_STAGE_HOST  -P$GO2_STAGE_PORT --single-transaction $SRC_DB $tab |  \
$MYSQL -u$STAGE_USER -p$STAGE_PWD -S$STAGE_SOCK $DST_DB
}


#
## main procedure
#
for tab in $TABS
do
   echo "refresh_tab_data $tab start at: `date '+%F %H:%m:%S'`"
   refresh_tab_data $tab
   echo "refresh_tab_data $tab end at: `date '+%F %H:%m:%S'`"
done
