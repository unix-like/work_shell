#!/bin/bash
#desc: backup  configure file

HOST=192.168.1.1
BAK_NAME_NGINX=nginx
BAK_NAME_PHP=php
BAK_NAME_SCRIPT=script
BAK_NAME_MYSQL=mysql
BAK_NAME_VARNISH=varnish
BAK_NAME_ES=elasticsearch
CONF_PATH_NGINX=/data/apps/nginx/conf
CONF_PATH_PHP=/data/apps/php/etc
CONF_PATH_SCRIPT=/data/scripts
CONF_PATH_MYSQL=/data/apps/mysql/etc
CONF_PATH_VARNISH=/data/apps/varnishd/etc
CONF_PATH_ES=/data/apps/elasticsearch
BAK_PATH=/tmp/backup/
BAK_DATE=$(date +%F)
TAR=/bin/tar

#备份数据
if [ ! -d ${BAK_PATH}${HOST} ];then
          mkdir -p ${BAK_PATH}${HOST}
fi

#cp -r ${CONF_PATH_NGINX} ${BAK_PATH}${HOST}/${BAK_NAME_NGINX}
#cp -r ${CONF_PATH_PHP} ${BAK_PATH}${HOST}/${BAK_NAME_PHP}
cp -r ${CONF_PATH_SCRIPT} ${BAK_PATH}${HOST}/${BAK_NAME_SCRIPT}
cp -r ${CONF_PATH_MYSQL} ${BAK_PATH}${HOST}/${BAK_NAME_MYSQL}
#cp -r ${CONF_PATH_VARNISH} ${BAK_PATH}${HOST}/${BAK_NAME_VARNISH}
#cp -r ${CONF_PATH_ES} ${BAK_PATH}${HOST}/${BAK_NAME_ES}
#ps -ef | grep varnish | grep -v grep > ${BAK_PATH}${HOST}/${BAK_NAME_VARNISH}.txt

${TAR} -cjf ${BAK_PATH}${HOST}_${BAK_DATE}.tar.bz2 ${BAK_PATH}${HOST}

#删除上面复制的本地文件
rm -rf ${BAK_PATH}${HOST}

#删除7天以上的本地打包备份数据

for tfile in $(/usr/bin/find ${BAK_PATH} -mtime +7)
       do
       rm -f ${tfile}
done
