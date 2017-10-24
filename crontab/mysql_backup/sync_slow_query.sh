#!/bin/bash


rsync -av --port 30004  --password-file=/etc/rsync.passwd /gotwo_data/Application/mysql/data/slow_query.log-`date +%Y%m%d`.gz backup@192.168.10.42::slow_query/mysql-slow.log-192.168.10.32-40003-`date +%Y%m%d`.gz
