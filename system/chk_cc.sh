#!/bin/sh
CUR_TIME=`date +%d/%b/%Y:%H:%M`
LOG_FILE="/gotwo_data/logs/nginx/www.go2.cn.access.log"
WEBSITE="www.test.cn"
IP="192.168.1.1"
OUTPUT_FILE="/tmp/chk_cc.txt"

echo " Website PV at ${CUR_TIME}  "  >  $OUTPUT_FILE
grep "$CUR_TIME"  $LOG_FILE | awk '{print $1}'|sort |uniq -c |sort -nrk1  |grep -v "$IP" |head >> $OUTPUT_FILE


acc_num=`sed -n '2p' $OUTPUT_FILE |awk '{print $1}' `

echo "The number of php-fpm processess is: " >> $OUTPUT_FILE
echo "ps -ef |grep php | wc -l " >> $OUTPUT_FILE
proc_num=`ps -ef |grep php | wc -l`
echo $proc_num  >> $OUTPUT_FILE

echo $acc_num
echo $proc_num 

if [ $acc_num -gt 300 ] && [ $proc_num -gt 1200 ]
then
    mailx -s"Maybe Telecom Website ${WEBSITE}(${IP}) is attacked by cc !!! Pls take action ASAP" yunwei@stargoto.com < $OUTPUT_FILE 2>/dev/null
fi
