#!/bin/bash

LOAD=`uptime | awk '{print $10}' | cut -d',' -f1 | cut -d'.' -f1`

if [ $LOAD -gt 80 ]
	then
	#pkill php-fpm
	#sleep 20
	/etc/init.d/php-fpm restart
	echo "系统负载达到 $LOAD ,重启php-fpm" | /bin/mail -s "Telecom Website www.go2.cn(125.64.16.26) 系统负载达到 $LOAD ,php-fpm已经重启" yunwei@stargoto.com
fi
