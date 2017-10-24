#!/bin/bash
REP_TIME_FILE="/tmp/reptime"
MYSQL_CLIENT="/usr/bin/mysql -urepchk_srd -pstargoto -h127.0.0.1 -P40006 "
restart()
{
$MYSQL_CLIENT -e "stop slave;start slave;"
sleep 1
$MYSQL_CLIENT -e "show slave status\G"
}

#
## main procedure
#

$MYSQL_CLIENT shipping_manager -e "select now master_time, now() slave_time,timestampdiff(SECOND,now,now()) diff_time from rep_latency;" > $REP_TIME_FILE

LATENCY=`sed -n '2p' $REP_TIME_FILE  |awk '{print $NF}'`
echo $LATENCY
LATENCY2=`$MYSQL_CLIENT -e "show slave status\G"|grep Seconds_Behind_Master|awk '{print $2}'`
echo $LATENCY2

#if [ $LATENCY -gt 60 ] && [ $LATENCY2 -gt 0 ] 
if [ $LATENCY -gt 600 ] 
then
        #echo 'send mail'
        #echo ""  >> $REP_TIME_FILE
        #restart  >> $REP_TIME_FILE

        mail -s"$HOSTNAME mysql GSB replication latency exceed 600s, pls check !"  yunwei@stargoto.com < $REP_TIME_FILE
fi
