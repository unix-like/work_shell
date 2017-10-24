#!/bin/bash
source ~/.cron_env

INNOBACKUPEX="/usr/bin/innobackupex"

MYSQL_USER=$STATS_ADM_USER
MYSQL_PWD=$STATS_ADM_PWD
MYSQL_SOCK=$STATS_ADM_SOCK
MYSQL_CNF_FILE="/gotwo_data/mysql_stats/my40005/etc/my40005.cnf"

BACKUP_DIR="/gotwo_data/backup"
DATA_DIR="/gotwo_data/mysql_stats/my40005/data"
SSH_CLIENT="ssh -p 40001 go2daipei@192.168.10.42"
SSH_CMD="cat > ${BACKUP_DIR}/mysql_stats_`date +%F`.xbstream"

$INNOBACKUPEX --defaults-file=$MYSQL_CNF_FILE --user=$MYSQL_USER --password=$MYSQL_PWD --socket=$MYSQL_SOCK  –-slave-info  --parallel=4 --compress --compress-threads 4 --no-version-check --stream=xbstream $DATA_DIR | $SSH_CLIENT "$SSH_CMD"

