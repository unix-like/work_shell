#!/bin/sh
#!/bin/bash
source ~/.cron_env

MYSQL_CLIENT="/usr/bin/mysql"
MYSQL_USER=$STATS_USER
MYSQL_PWD=$STATS_PWD
MYSQL_SOCK=$STATS_SOCK
STAMP_FILE="/gotwo_data/scripts/last_timestamp"
FILE_NAME="statistic_product_daily_`date +%F`"
TIME_STAMP="`sed -n '2p' $STAMP_FILE`"
DATA_DIR="/gotwo_data/backup/mysql/daily/"

#TIME_STAMP="2017-07-11 00:00:00"
echo $TIME_STAMP
SQL="select * from db_stats.statistic_product_daily where create_date > \"$TIME_STAMP\" into outfile '/tmp/$FILE_NAME'"
echo $SQL
mysql -u$MYSQL_USER -p$MYSQL_PWD --socket=$MYSQL_SOCK  -e "$SQL"
#echo "mysql -u$MYSQL_USER -p$MYSQL_PWD --socket=$MYSQL_SOCK "
mysql -u$MYSQL_USER -p$MYSQL_PWD --socket=$MYSQL_SOCK  -e "select max(create_date) from db_stats.statistic_product_daily" > $STAMP_FILE

mv /tmp/${FILE_NAME}  ${DATA_DIR}
