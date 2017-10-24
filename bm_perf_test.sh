#!/bin/bash


if [ "$#" -ne "2" ]
then
echo "USAGE: `basename $0` disktype[sas,ssd] testmode[rndwr,rndrd,rndrw,seqwr,seqrd,seqrewr]"
exit
fi

DISK_TYPE=$1
TEST_MODE=$2

BASE_DIR="/gotwo_data/ssd2"
LOG_DIR="/gotwo_data/perf_log"

case $TEST_MODE in
"seqrewr")
   FILE_BLOCK_SIZE=$[4*1024*1024];;
"rndrw")
   FILE_BLOCK_SIZE=$[16*1024];; 
*) 
   FILE_BLOCK_SIZE=$[16*1024];;  
esac
echo $FILE_BLOCK_SIZE

SYSBENCH="sysbench --test=fileio --file-total-size=10G --file-block-size=${FILE_BLOCK_SIZE}"

NUM_THREADS="1 5 10 20 50"
#NUM_THREADS="50"


cd $BASE_DIR

#prepare benchmask testing data
echo "$SYSBENCH --num-threads=10 --file-test-mode=$TEST_MODE prepare "
$SYSBENCH --num-threads=10 --file-test-mode=$TEST_MODE prepare 

for i in $NUM_THREADS
do

#clear cache before benchmask testing
echo 1 > /proc/sys/vm/drop_caches

TEST_LOG_FILE="${LOG_DIR}/${DISK_TYPE}_${TEST_MODE}_${i}.LOG"

echo "$SYSBENCH --num-threads=$i --file-test-mode=$TEST_MODE run > $TEST_LOG_FILE "
$SYSBENCH --num-threads=$i --file-test-mode=$TEST_MODE run > $TEST_LOG_FILE 

done

#clearup benchmask testing data
echo ""
echo "$SYSBENCH --num-threads=10 --file-test-mode=$TEST_MODE cleanup "
$SYSBENCH --num-threads=10 --file-test-mode=$TEST_MODE cleanup 



