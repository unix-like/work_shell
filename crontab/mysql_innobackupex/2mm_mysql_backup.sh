#!/bin/bash

INNOBACKUPEX=`which innobackupex`
CURL=`which curl`
RSYNC=`which rsync`
BWLIMIT=40960 #40MB

HOST_IP='192.168.10.42'
REMOTE_IP='192.168.10.42'



MYSQL_USER="root"
MYSQL_PWD="es@7ZnCSJhN1v1js"
MYSQL_SOCKET="/gotwo_data/mysql/db2mm/socket/mysqld.sock"
MYSQL_PORT=40004
MYSQL_CNF_FILE="/gotwo_data/mysql/db2mm/etc/my40004.cnf"
INSTNANCE_NAME="db2mm"

BACKUP_DIR="/gotwo_data/backup/mysql/mysql_innobackupex/db_2mm"
BACKUP_FILE="mysql-"$INSTNANCE_NAME
BACKUP_FILES_DIR="mysql-"$INSTNANCE_NAME
TRANSFER_FILE=

WEEK=`date +%w`
#WEEK=`date -d yesterday +%w`
CUR_DATE=`date +%F`



RUN_THREAD_NUM=2
COMPRESS_THREAD_NUM=2

SENTO="yunwei@stargoto.com"

SUBJECT="MySQL Instance ${INSTNANCE_NAME} backup Error"

BACKUP_LOG=$BACKUP_DIR"/backup.log"


BINARY_BACKUP()
{
    TRANSFER_FILE=$BACKUP_FILE"-"$CUR_DATE".xbstream"


    #$INNOBACKUPEX --user=$MYSQL_USER  --password=$MYSQL_PWD --socket=$MYSQL_SOCKET --slave-info  --parallel=$RUN_THREAD_NUM --compress --compress-threads $COMPRESS_THREAD_NUM --defaults-file=$MYSQL_CNF_FILE --no-version-check --stream=xbstream  $BACKUP_DIR  > $BACKUP_DIR/$TRANSFER_FILE
   $INNOBACKUPEX --defaults-file=$MYSQL_CNF_FILE  --user=$MYSQL_USER  --password=$MYSQL_PWD --socket=$MYSQL_SOCKET --slave-info  --parallel=$RUN_THREAD_NUM --compress --compress-threads $COMPRESS_THREAD_NUM --no-version-check --stream=xbstream  $BACKUP_DIR  > $BACKUP_DIR/$TRANSFER_FILE

    sleep 10

    sleep 10

   cat $BACKUP_LOG |  grep  -v "prints"  | grep "completed OK"  > /dev/null

    if [ $? -eq 0 ]
    then
           echo "Backup finish successfully !"
           echo "Backup $INSTNANCE_NAME(2mm,bag8) completed successfully !" |  mailx -s "$INSTNANCE_NAME backup status" $SENTO
       else
              #$CURL -d "menu=errorlog" -d email_destinations="$SENTO" -d email_subject="$SUBJECT" -d email_content="${HOST_IP} MYSQL INSTANCE $INSTNANCE_NAME backup failed,please check !" http://email.int.jumei.com/send
           echo "Backup failed, pls check" | mailx -s "$SUBJECT" $SENTO
          fi

      }

      RSYNC_REMOTE()
      (
      $RSYNC -av --bwlimit=$BWLIMIT $BACKUP_DIR/$TRANSFER_FILE root@${REMOTE_IP}::mysql/

      if [ $? -eq 0 ];then
                  rm -f $BACKUP_DIR/$TRANSFER_FILE
              else
                    $CURL -d "menu=errorlog" -d email_destinations="$SENTO" -d email_subject="$SUBJECT" -d email_content="${HOST_IP} backup  file send to ${REMOTE_IP} failed,please check !" http://email.int.jumei.com/send
      fi
                )

#
# main procedure
#

BINARY_BACKUP

#RSYNC_REMOTE

