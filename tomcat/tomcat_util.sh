#!/bin/bash

usage() {
        printf "
tomcat_until usage and overview
USAGE: tomcat_util options


Here is the list of commands available:
1. createTomcat port_prefix(100<port_prefix<600) seq_no(0<=seq_no<=9)
    e.g createTomcat 430 1
2. createProj project_name
3. deployWar [war_file]
"

}
createConf() {
PROJ_DIR="tomcat"
CONF_DIR="/gotwo_data/scripts/tomcat/conf"


}

createTomcat() {
#echo $#

[ $# -ne 2 ] && printf "invalid command option,the COMMAND 'createTomcat' as below
createTomcat proj_code seq_no
e.g createTomcat 430 1
" && exit 

PROJ_CODE=$1
TOMCAT_SEQ=$2

WEB_PORT="${PROJ_CODE}${TOMCAT_SEQ}0"
SSL_PORT="${PROJ_CODE}${TOMCAT_SEQ}3"
SHUTDOWN_PORT="${PROJ_CODE}${TOMCAT_SEQ}5"
JMX_PORT="${PROJ_CODE}${TOMCAT_SEQ}8"
APACHE_PORT="${PROJ_CODE}${TOMCAT_SEQ}9"

TOMCAT_PKG="/gotwo_data/scripts/tomcat/template/tomcat"
DEST_TOMCAT_DIR="/gotwo_data/Application/tomcat${WEB_PORT}"
CATA_TEMPLATE="${DEST_TOMCAT_DIR}/bin/catalina.sh"
XML_TEMPLATE="${DEST_TOMCAT_DIR}/conf/server.xml"

cp -r $TOMCAT_PKG $DEST_TOMCAT_DIR

sed -i "s/##WEB_PORT##/${WEB_PORT}/g" $XML_TEMPLATE
sed -i "s/##SSL_PORT##/${SSL_PORT}/g" $XML_TEMPLATE
sed -i "s/##SHUTDOWN_PORT##/${SHUTDOWN_PORT}/g" $XML_TEMPLATE
sed -i "s/##WEB_PORT##/${WEB_PORT}/g" $CATA_TEMPLATE
sed -i "s/##JMX_PORT##/${JMX_PORT}/g" $CATA_TEMPLATE

rm -rf ${DEST_TOMCAT_DIR}/webapps/*

chown -R tomcat.tomcat $DEST_TOMCAT_DIR

}

deployWar() {
echo $@
}


createProj() {
echo $@
#PROJ_DIR=$1
PROJ_NAME=$1
CONF_DIR="/gotwo_data/scripts/tomcat/conf"
PROJ_DIR="/gotwo_data/scripts/tomcat/conf/${PROJ_NAME}"

if [ -d $PROJ_DIR ] 
then
   echo "The Projct $PROJ_NAME has existed , pls change another Project name !!"
else
   mkdir -p $PROJ_DIR/{common,individual}
fi

}

#
# main procedure
#

cmd="$1"

[ -n "$1" ] && shift

case "$cmd" in
        createTomcat)
                createTomcat "$@"
                ;;
        createProj)
                createProj "$@"
                ;;
        deployWar)
                deployWar "$@"
                ;;
        ""|help|-h|--help|--usage)
                usage
                exit 0
                ;;
        *)
                echo "Unknown command '$cmd'. Run without commands for usage help."
                ;;
esac
#usage
