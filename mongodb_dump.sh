#!/bin/bash
DB_NAME="userBehavior_`date +%Y%m`"
#echo $DB_NAME
echo "/usr/bin/mongodump --gzip -d $DB_NAME -o /gotwo_data/backup/mongodb/`date +%F` &>> /gotwo_data/logs/dump_mongo.log"

rm -rf /gotwo_data/backup/mongodb/userBehavior* 

/usr/bin/mongodump --gzip -d $DB_NAME -o /gotwo_data/backup/mongodb/userBehavior_`date +%F` &>> /gotwo_data/logs/dump_mongo.log

#/usr/bin/mongodump --gzip -d userBehavior -o /gotwo_data/backup/mongodb/`date +%F` &>> /gotwo_data/logs/dump_mongo.log
