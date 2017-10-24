#!/bin/bash
source ~/.cron_env

MYSQL_CLIENT="/usr/bin/mysql"

MYSQL_USER=$SYS_MYSQL_USER
MYSQL_PWD=$SYS_MYSQL_PWD
MYSQL_SOCK=$SYS_MYSQL_SOCK
MYSQL_CMD="show processlist"

BASE_DIR="/gotwo_data/backup/snapshot"
SNAP_FILE="${BASE_DIR}/dbPub_`date +%Y%m%d`.snap"

echo "$MYSQL_CLIENT --user=$MYSQL_USER  --password=$MYSQL_PWD --socket=$MYSQL_SOCK -e \"$MYSQL_CMD\""

echo "" >> $SNAP_FILE
echo "" >> $SNAP_FILE
date '+%Y%m%d %H:%M:%S' >> $SNAP_FILE
echo "" >> $SNAP_FILE
$MYSQL_CLIENT --user=$MYSQL_USER  --password=$MYSQL_PWD --socket=$MYSQL_SOCK -e "$MYSQL_CMD" | grep -v "Sleep" >> $SNAP_FILE  
$MYSQL_PWD
echo -e "\nThe blocking is:\n" >>  $SNAP_FILE
$MYSQL_CLIENT --user=$MYSQL_USER --password=${MYSQL_PWD}  --socket=$MYSQL_SOCK  <<+  >>  $SNAP_FILE
select 
it.trx_mysql_thread_id,it.trx_state, ilw.blocking_trx_id,ilw.requesting_trx_id,pl.time             
from information_schema.INNODB_TRX it, 
information_schema.INNODB_LOCK_WAITS ilw, information_schema.processlist pl 
where it.trx_id = ilw.blocking_trx_id
and pl.id=it.trx_mysql_thread_id
+
