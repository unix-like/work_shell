#bin/bash

redis_file=/gotwo_data/Application/redis/data/6379/dump.rdb

RSYNC=/usr/bin/rsync

$RSYNC  --port 30004 --password-file=/etc/rsync.passwd $redis_file backup@192.168.10.42::redis_backup/go2_`date +%F`_dump.rdb
