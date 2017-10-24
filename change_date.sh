#!/bin/bash

# CHANGE service_end_date

MYSQL_USER=root
MYSQL_PASSWD=XcQVr8CmHhs4FVN2
MYSQL_HOST=127.0.0.1
MYSQL_PORT=40003
MYSQL_DATABASE=db_go2
MYSQL_BIN=/gotwo_data/Application/mysql/bin/mysql


read -p 'please in put user_id:' USER_ID


echo
echo "user details:"

${MYSQL_BIN} -u${MYSQL_USER} -p${MYSQL_PASSWD}  -h ${MYSQL_HOST} -P ${MYSQL_PORT}  -e  "select * from ${MYSQL_DATABASE}.supplier where user_id=${USER_ID}\G"



echo
read -p 'are you sure to change this date?[y|n]' CHANGE


case ${CHANGE} in
	yes|y|Y)
	read -p 'please in put the new service_end_date:' DATE
	${MYSQL_BIN} -u${MYSQL_USER} -p${MYSQL_PASSWD}  -h ${MYSQL_HOST} -P ${MYSQL_PORT}  -e  "select * from ${MYSQL_DATABASE}.supplier where user_id=${USER_ID} into outfile '/gotwo_data/backup/adhoc/${USER_ID}_`date +%F`.bak'"
	${MYSQL_BIN} -u${MYSQL_USER} -p${MYSQL_PASSWD}  -h ${MYSQL_HOST} -P ${MYSQL_PORT} -e "update ${MYSQL_DATABASE}.supplier set service_end_date="${DATE}" where user_id=${USER_ID}"
	echo 
	echo "result:"
	${MYSQL_BIN} -u${MYSQL_USER} -p${MYSQL_PASSWD}  -h ${MYSQL_HOST} -P ${MYSQL_PORT}  -e  "select * from ${MYSQL_DATABASE}.supplier where user_id=${USER_ID}\G"
	;;

	no|n|Y)
	exit
	;;

	*)
	echo "please input right option"
	;;
esac

