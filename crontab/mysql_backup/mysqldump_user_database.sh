#!/bin/bash -
# # # # # # # # # # # #
#                     #
# 备份本机指定数据库  #
#                     #
# # # # # # # # # # # #

echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份开始执行！";

function dump_db() {
  # 数据库备份文件保存路径
  path="/data/backup/mysql/daily/";
  # 数据库备份文件名
  file="daily_$1_`date +%Y-%m-%d_%Hh%Mm_user`.sql";
  # 将数据库导出到文件
  echo "`date +%Y-%m-%d\ %H:%M:%S`    开始导出数据库！";
  /gotwo_data/Application/mysql/bin/mysqldump -uroot -pXcQVr8CmHhs4FVN2 $1 user > ${path}${file} && gzip ${path}${file} 
  #/gotwo_data/Application/mysql/bin/mysqldump -uroot -pXcQVr8CmHhs4FVN2 $1 user  -t -T /tmp/ --fields-terminated-by=, --fields-enclosed-by=\" 
  #if [ -f /tmp/user.txt ] && [ -s /tmp/user.txt ]
  #then
#	mv /tmp/user.txt $path${file} && gzip ${path}${file}
   #else 
#	echo "faild."
#  fi 	

}

# 备份db_go2库
dump_db 'db_go2';

echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份执行结束！";
echo
