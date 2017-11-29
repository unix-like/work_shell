#!/bin/bash -
# # # # # # # # # # # #
#                     #
# 备份本机指定数据库  #
#                     #
# # # # # # # # # # # #

echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份开始执行！";
echo

function dump_db() {
  # 数据库备份文件保存路径
  path="/data/backup/mysql/daily/$1/";
  # 数据库备份文件名
  #file="daily_$1_`date +%Y-%m-%d_%Hh%Mm_%A`.sql";
  file="daily_$1_`date +%F`.sql";
  # 将数据库导出到文件
  echo "`date +%Y-%m-%d\ %H:%M:%S`    开始导出数据库！";
 /gotwo_data/Application/mysql/bin/mysqldump -uroot -pxxxxxxxx --single-transaction $1 > ${path}${file} && gzip ${path}${file} 
  # 删除超过7天的备份
  echo "`date +%Y-%m-%d\ %H:%M:%S`    删除超过7天的备份！";
  ls $path | grep `date --date='-7 day' +%y-%m-%d` | xargs rm 2>/dev/null
}

# 备份db_go2库
dump_db 'db_go2';

echo "`date +%Y-%m-%d\ %H:%M:%S`    数据库备份执行结束！";
echo
echo
