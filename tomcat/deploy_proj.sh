#!/bin/bash

TOMCAT_PORT=$1
PROJ_FILE=$2

BASE_DIR="/gotwo_data/Application/tomcat"
TOMCAT_DIR="${BASE_DIR}${TOMCAT_PORT}"
WORK_DIR="${TOMCAT_DIR}/work"
WEBAPPS_DIR="${TOMCAT_DIR}/webapps"
UPLOAD_BAK_DIR="$WEBAPPS_DIR/upload_`date +%F`"
BIN_DIR="${TOMCAT_DIR}/bin"

UNZIP=`which unzip`

#Stop tomcat instance
echo "Shutdown Tomcat $TOMCAT_PORT instance ..."
sudo sh ${BIN_DIR}/catalina.sh stop
sleep 10

#ps -ef|grep "tomcat${TOMCAT_PORT}"
ps -ef|grep "tomcat${TOMCAT_PORT}"|grep -v "grep" > /dev/null

while [ "$?" == "0" ]
do
   sleep 5
done

echo "Shutdown completed !"

if [ "$TOMCAT_PORT" == "18000" ]
then
   echo "purge web cache ..."
   rm -rf /gotwo_data/sites/proxycache/*
   mv $WEBAPPS_DIR/ROOT/ueditor/jsp/upload $UPLOAD_BAK_DIR
fi

echo "Remove war package with last version ......"
rm -rf ${WORK_DIR}/*
rm -rf ${WEBAPPS_DIR}/ROOT/
mv ${WEBAPPS_DIR}/ROOT.war ${WEBAPPS_DIR}/ROOT.war`date +%F`
mv $PROJ_FILE ${WEBAPPS_DIR}/ROOT.war

#chown tomcat.tomcat ${WEBAPPS_DIR}/ROOT.war
sudo -u tomcat $UNZIP ${WEBAPPS_DIR}/ROOT.war -d ${WEBAPPS_DIR}/ROOT
cp -f ${WEBAPPS_DIR}/x.properties  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/x.properties
cp -f ${WEBAPPS_DIR}/logback.xml  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/logback.xml
cp -f ${WEBAPPS_DIR}/IOC.xml  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/IOC.xml
cp -f ${WEBAPPS_DIR}/db.properties  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/db.properties
cp -f ${WEBAPPS_DIR}/task.xml  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/task.xml
cp -f ${WEBAPPS_DIR}/producer.properties  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/producer.properties
cp -f ${WEBAPPS_DIR}/consumer.properties  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/consumer.properties
cp -f ${WEBAPPS_DIR}/smvc-servlet.xml  ${WEBAPPS_DIR}/ROOT/WEB-INF/classes/smvc-servlet.xml

if [ "$TOMCAT_PORT" == "18000" ]
then
   rm -rf $WEBAPPS_DIR/ROOT/ueditor/jsp/upload/* 
   mkdir -p $WEBAPPS_DIR/ROOT/ueditor/jsp/upload
   cp -rf $UPLOAD_BAK_DIR/*  $WEBAPPS_DIR/ROOT/ueditor/jsp/upload/
fi

chown -R tomcat.tomcat $WEBAPPS_DIR

echo "Startup Tomcat $TOMCAT_PORT instance ..."
sudo -u tomcat sh ${BIN_DIR}/catalina.sh start

echo "Startup completed !"

ps -ef|grep "tomcat${TOMCAT_PORT}"



