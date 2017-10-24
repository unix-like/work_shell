#!/bin/sh
CORE_NUM=$1
ITEM=$2

CMD="/usr/bin/sar -P ALL 1 1"
CACHEFILE="/tmp/localhost-cpu_cores_stats.txt"

if [ -e $CACHEFILE ]; then
    # Check and run the script
    #TIMEFLM=`stat -c %Y /tmp/$HOST-mysql_cacti_stats.txt`
    TIMEFLM=`stat -c %Y $CACHEFILE`
    TIMENOW=`date +%s`
    if [ `expr $TIMENOW - $TIMEFLM` -gt 60 ]; then
        rm -f $CACHEFILE
        #$CMD 2>&1 > /dev/null
        $CMD > $CACHEFILE 2> /dev/null
    fi
else
    $CMD > $CACHEFILE 2> /dev/null
fi

FLITER=`printf "Average:%11s" $CORE_NUM`

case $ITEM in
  idle)
      grep "$FLITER" $CACHEFILE|awk '{print $8}'
  ;;
  steal)
      grep "$FLITER" $CACHEFILE|awk '{print $7}'
  ;;
  iowait)
      grep "$FLITER" $CACHEFILE|awk '{print $6}'
  ;;
  system)
      grep "$FLITER" $CACHEFILE|awk '{print $5}'
  ;;
  nice)
      grep "$FLITER" $CACHEFILE|awk '{print $4}'
  ;;
  user)
      grep "$FLITER" $CACHEFILE|awk '{print $3}'
  ;;
  *)
  exit
esac
