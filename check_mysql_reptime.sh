#!/bin/bash
REP_TIME_FILE="/tmp/reptime"

restart()
{
/usr/bin/mysql db_go2 -e "stop slave;start slave;"
sleep 1
/usr/bin/mysql db_go2 -e "show slave status\G"
}

#
## main procedure
#

/usr/bin/mysql db_go2 -e "select now master_time, now() slave_time,timestampdiff(SECOND,now,now()) diff_time from rep_latency;" > $REP_TIME_FILE

LATENCY=`sed -n '2p' $REP_TIME_FILE  |awk '{print $NF}'`
echo $LATENCY
LATENCY2=`/usr/bin/mysql -e "show slave status\G"|grep Seconds_Behind_Master|awk '{print $2}'`
echo $LATENCY2

if [ $LATENCY -gt 120 ] 
then
	#echo 'send mail'
	echo ""  >> $REP_TIME_FILE
	restart  >> $REP_TIME_FILE

	mail -s"$HOSTNAME mysql replication latency exceed 60s, pls check !"  yunwei@stargoto.com < $REP_TIME_FILE
fi

