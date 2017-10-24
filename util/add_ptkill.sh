#!/bin/bash

source ~/.cron_env

MYSQL_USER=$SYS_MYSQL_USER
MYSQL_PWD=$SYS_MYSQL_PWD
MYSQL_SOCK=$SYS_MYSQL_SOCK

PTKILL="/usr/bin/pt-kill"
log_file="/gotwo_data/logs/pt-kill/kill_`date +%F%H%M%S`.log"

#ps -ef|grep pt-kill |grep -v grep |awk '{print $2}' |xargs kill -9
kill -9 `cat /tmp/ptkill.pid`

$PTKILL  --user=$MYSQL_USER  --password=$MYSQL_PWD --socket=$MYSQL_SOCK --busy-time 60 --ignore-user="root|searchmgt_swd" --ignore-command="Sleep|Binlog Dump" --victim all --interval 1 --kill --daemonize --pid=/tmp/ptkill.pid --print --log=/home/go2daipei/pt-kill.log

