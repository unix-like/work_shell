#!/gotwo_data/Application/redis/env python
#-*-coding:UTF-8-*-

import os,sys,time

def conf_w(host,port,flag,master_host='',master_port=''):
	text = '''daemonize yes
pidfile /var/run/redis/redis_27000.pid
port 27000
bind 0.0.0.0
tcp-backlog 2048
timeout 0
tcp-keepalive 0
maxclients 5000
maxmemory 8589934592
loglevel notice
logfile /gotwo_data/logs/redis/redis.log
databases 16
save 43200 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /gotwo_data/Application/redis/27000
slave-serve-stale-data yes
#slaveof no one
slave-read-only yes
repl-ping-slave-period 1
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
#appendfilename appendonly.aof
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 50
auto-aof-rewrite-min-size 128mb
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes'''
	path_list = ["/var/run/redis","/gotwo_data/Application/redis","/var/log/redis","/gotwo_data/Application/redis/%s" % port]
	for dirs in path_list:
		if not os.path.isdir(dirs):
			os.makedirs(dirs)
	text = text.replace('27000',port)
	text = text.replace('0.0.0.0',host)
	if flag == "slave":
		print master_host,master_port
		text = text.replace("#slaveof no one","slaveof %s %s" % (master_host,master_port))
		text = text.replace("appendonly no","appendonly yes")
		text = text.replace("#appendfilename appendonly.aof","appendfilename appendonly.aof")
	conf_file = "/gotwo_data/Application/redis/redis_%s.conf" % port
	f = open(conf_file,'w+')
	f.write(text)
	f.close()
	files = open( "/etc/rc.local", "r" ).read()
	if "exit 0" in files:
		server_start = "/gotwo_data/Application/redis/redis-server %s\nexit 0" % conf_file
		server_start = files.replace('exit 0',server_start)
	else:
		server_start = "/gotwo_data/Application/redis/redis-server %s\n" % conf_file
	rc_local = "/etc/rc.local"
	f = open(rc_local,'w+')
	f.write(server_start)
	f.close()
	res = os.popen("/gotwo_data/Application/redis/redis-server %s" % conf_file).readlines()
	if len(res) == 0:
		print "%s:%s Start OK ..." % (host,port)
	else:
		print res
	time.sleep(5)
	print
	os.system("/bin/netstat -ntlp|grep redis")
	#os.system("/bin/ps -ef | grep redis")
def main():
	print
        print "请选择操作类型：\n\n\t0:部署redis主库\n\t1:部署redis从库\n\n\t按任意键退出部署"
	choose = raw_input('Your Choose : ')
	ip_list = [["192.168.2.90:27002","10.1.7.223:27000"]]
	if choose == "0":
		for i in ip_list:
			tmp = i[0].split(':')
			host = tmp[0]
			port = tmp[1]
			conf_w(host,port,"master")
	elif choose == "1":
		for i in ip_list:
			tmp = i[1].split(':')
			host = tmp[0]
			port = tmp[1]
			tmp = i[0].split(':')
			master_host = tmp[0]
			master_port = tmp[1]
			conf_w(host,port,"slave",master_host,master_port)
	else:
		print "已退出部署"
	print

if __name__ == "__main__":
	main()


