#!/bin/sh

BASE_DIR="/gotwo_data/scripts"
DATA_DIR="/gotwo_data/backup/mongodb/"

DUMP_FILE=`ls -lt ${BASE_DIR}/dump.trc*|head -1 | awk '{print $NF}'`
echo $DUMP_FILE
cp -f  $DUMP_FILE ${BASE_DIR}/"dump.trc"

#python /gotwo_data/scripts/sync_userBehavior.py
python /gotwo_data/scripts/mongo_dump_data.py

cd $DATA_DIR
INC_DIR="`date +'%Y-%m-%d'`_inc"
FW_DIR="`date +'%Y-%m-%d'`_all"
#echo $DATA_DIR
#echo $INC_DIR

tar zcvf "${INC_DIR}.tgz" ${INC_DIR}
tar zcvf "${FW_DIR}.tgz" ${FW_DIR}

rm -rf $INC_DIR
rm -rf ${FW_DIR}
