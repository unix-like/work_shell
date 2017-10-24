#!/bin/bash -
# # # # # # # # # # # #
#                     #
# 备份本机指定数据库  #
#                     #
# # # # # # # # # # # #
echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份开始执行！";

function dump_db() {
  # 数据库备份文件保存路径
  path="/gotwo_data/backup/mysql/mysql_dump/daily_user/$1/";
  # 数据库备份文件名
  file="daily_$1_`date +%Y-%m-%d_%Hh%Mm_user`.sql";
  # 将数据库导出到文件
  echo "`date +%Y-%m-%d\ %H:%M:%S`    开始导出数据库！";
  /usr/bin/mysqldump -uroot -p'es@7ZnCSJhN1v1js' --socket /gotwo_data/mysql/db2mm/socket/mysqld.sock --port 40004 --single-transaction $1 user > ${path}${file} && gzip ${path}${file}
  #mysqldump -uroot -pdahuangya $1 user  -t -T /tmp/ --fields-terminated-by=, --fields-enclosed-by=\"
  #if [ -f /tmp/user.txt ] && [ -s /tmp/user.txt ]
  #then
  #      mv /tmp/user.txt $path${file} && gzip ${path}${file}
  # else
  #      echo "faild."
  #fi


}

# 备份db_2mm user表
dump_db 'db_2mm';
echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份执行结束！";
echo
