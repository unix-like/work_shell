#!/bin/bash -

# mysql数据库登录账号
user='root'
# mysql数据库登录密码
pass='leweisa'

#测试db_ad库
db1='db_ad'

#gsb
db2='shipping_manager'

#测试db_bag8库
db8='db_bag8'

#测试go2plus_photography库
db10='go2plus_photography'

# 测试db_go2库
db4='db_go2'

# 测试db_2mm库
db5='db_2mm'

# 测试db_3e3e库
db6='db_3e3e'

# 测试db_sys库
db12='db_sys'

# 测试db_sms库
db3='db_sms'

# db_go2,db_3e3e,db_2mm,db_bag8,db_sys,go2plus_photography库在线上的备份服务器
server1='1.1.1.1'
server2='2.2.2.2'


# 删除老数据库备份，下载最新数据库备份
function rsync_db() {
  showMsg "开始同步数据库$2..."
  file=`rsync --port 30004 --list-only --password-file=/etc/rsync.passwd backup@$1::mysql_backup/$2/ | tail -1 | awk '{print $5}'`
  path="/gotwo_data/backup/mysql/$2/"

  if [ ! -f ${path}${file} ]
  then
    showMsg "删除老数据库备份..."
    rm ${path}*.* 2>/dev/null
    showMsg "下载最新的数据库备份..."
    rsync -av --port 30004 --password-file=/etc/rsync.passwd backup@$1::mysql_backup/$2/${file} ${path}

  else
    showMsg ${path}${file}"文件已存在！"
  fi
}


#导入数据库
function restore_db_40003() {
   # showMsg "开始同步数据库$1..."
    file=`ls /gotwo_data/backup/mysql/$1`
    path="/gotwo_data/backup/mysql/$1/"


    showMsg "将最新的${1}数据库备份导入测试数据库40003..."
    gzip -d < ${path}${file} | mysql -u${user} -p${pass} --socket=/gotwo_data/mysql/my40003/socket/mysqld.sock $1 2>/dev/null
}


function restore_db_40004() {
   # showMsg "开始同步数据库$1..."
    file=`ls /gotwo_data/backup/mysql/$1`
    path="/gotwo_data/backup/mysql/$1/"

    showMsg "将最新的${1}数据库备份导入测试数据库40004..."
    gzip -d < ${path}${file} | mysql -u${user} -p${pass} --socket=/gotwo_data/mysql2/my40004/socket/mysqld.sock $1 2>/dev/null
}


function restore_db_40005() {
   # showMsg "开始同步数据库$1..."
    file=`ls /gotwo_data/backup/mysql/$1`
    path="/gotwo_data/backup/mysql/$1/"

    showMsg "将最新的${1}数据库备份导入测试数据库40005..."
    gzip -d < ${path}${file} | mysql -u${user} -p${pass} -h192.168.10.203 -P40005 $1
}


# 格式化输出日志
function showMsg() {
  echo "`date +%Y-%m-%d\ %H:%M:%S`    $1"
}

showMsg "开始同步数据库！"

#go2 同步
rsync_db $server1 $db4
#
###2mm 同步
##rsync_db $server1 $db5
#
###3e3e同步
#rsync_db $server1 $db6
#
###bag8同步
##rsync_db $server1 $db8 
#
###go2plus_photography同步
rsync_db $server1 $db10
#
###db_sys同步
#rsync_db $server1 $db12
#
###db_ad同步
rsync_db $server1 $db1
#
###shipping_manager同步
#rsync_db $server2 $db2
#
##db_sms同步
rsync_db $server1 $db3

echo
echo

showMsg "开始导入数据库！"

#############40003#############

#go2导入
restore_db_40003 db_go2 &

#shipping_manager导入
#restore_db_40003 shipping_manager &

#2mm 导入
#restore_db_40003 db_2mm &

#3e3e导入
restore_db_40003 db_3e3e 

#bag8导入
#restore_db_40003 db_bag8 

#go2plus_photography导入
restore_db_40003 go2plus_photography

#db_sys导入
#restore_db_40003 db_sys

##db_ad导入
restore_db_40003 db_ad

#db_sms导入
#restore_db_40003 db_sms

############40004#################

#go2导入
#restore_db_40005 db_go2 

##2mm 导入
#restore_db_40004 db_2mm &

##3e3e导入
#restore_db_40005 db_3e3e

##bag8导入
#restore_db_40005 db_bag8

##go2plus_photography导入
#restore_db_40004 go2plus_photography

##db_sys导入
#restore_db_40004 db_sys

##db_ad导入
#restore_db_40005 db_ad

#db_sms导入
#restore_db_40004 db_sms

showMsg "备份恢复脚本执行完成！"
echo

/usr/bin/python /gotwo_data/scripts/cronjob/hide_data.py 192.168.10.13 40003
/usr/bin/python /gotwo_data/scripts/cronjob/hide_data.py 192.168.10.203 40005
