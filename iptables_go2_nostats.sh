#!/bin/bash

IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe

####IP4
echo "[+] Flushing existing $IPTABLES rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -t filter -P INPUT DROP
$IPTABLES -t filter -P OUTPUT DROP
$IPTABLES -t filter -P FORWARD DROP

### load connection-tracking modules
echo "[+] Modprode iptables modle..."
$MODPROBE ip_conntrack
$MODPROBE iptable_nat
$MODPROBE ip_conntrack_ftp
$MODPROBE ip_nat_ftp

########IP4
echo "[+] Setting up OUTPUT chain..."
$IPTABLES -t filter -A INPUT -i lo -j ACCEPT
$IPTABLES -t filter -A OUTPUT -o lo -j ACCEPT

#SSH PORT
$IPTABLES -t filter -A INPUT -p tcp  --dport 40001   -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --sport 40001 -j ACCEPT

#ping limit
$IPTABLES -t filter -A INPUT -p icmp  -m state --state NEW,ESTABLISHED,RELATED  -m icmp --icmp-type echo-request    -m limit --limit 10/second  -j ACCEPT
$IPTABLES -t filter -A INPUT -p icmp  -m state --state NEW,ESTABLISHED,RELATED  -m icmp --icmp-type echo-reply    -m limit --limit 10/second  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED    -j ACCEPT


$IPTABLES -t filter -A INPUT -p tcp  --dport 3306   -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --sport 3306 -j ACCEPT

#NTP PORT
$IPTABLES -t filter -A INPUT   -p tcp --dport 123   -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp --sport 123    -j ACCEPT

$IPTABLES -t filter -A INPUT   -p udp --dport 123 -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p udp --sport 123 -j ACCEPT


#MYSQL
$IPTABLES -t filter -A INPUT  -p tcp -s 121.40.36.212 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.40.36.212 --sport 40003 -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 121.199.176.114 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.199.176.114 --sport 40003 -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 125.64.14.22 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 125.64.14.22  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 121.43.150.144 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.43.150.144  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 192.168.10.30 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 192.168.10.30  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 192.168.10.31 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 192.168.10.31  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 120.26.138.49 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 120.26.138.49  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 125.64.19.224 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 125.64.19.224  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 121.40.252.202 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.40.252.202  --sport 40003  -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 121.199.58.143 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.199.58.143  --sport 40003  -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 120.27.194.114 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 120.27.194.114  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 121.40.49.134 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.40.49.134  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 120.27.192.135 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 120.27.192.135  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 118.178.234.43 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 118.178.234.43  --sport 40003  -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 114.55.35.72 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 114.55.35.72  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 114.55.108.122 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 114.55.108.122 --sport 40003  -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 120.27.192.169 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 120.27.192.169  --sport 40003  -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 116.62.28.152 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 116.62.28.152  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 118.31.112.251 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 118.31.112.251  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 114.55.140.202 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 114.55.140.202  --sport 40003  -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 116.62.31.64 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 116.62.31.64 --sport 40003  -j ACCEPT
#REDISS
$IPTABLES -t filter -A INPUT  -p tcp -s 121.40.36.212 --dport 6379  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.40.36.212 --sport 6379 -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 192.168.10.31 --dport 6379  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 192.168.10.31 --sport 6379 -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 121.40.252.202 --dport 6379  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.40.252.202 --sport 6379 -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 116.62.28.152 --dport 6379  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 116.62.28.152 --sport 6379 -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 114.55.108.122 --dport 6379  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 114.55.108.122 --sport 6379 -j ACCEPT

#eapi.ximgs.net called
$IPTABLES -t filter -A INPUT  -p tcp -s  121.199.176.178  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d  121.199.176.178    -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -s 121.199.170.14  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.199.170.14    -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -s 121.199.160.248  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 121.199.160.248    -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -s 112.124.55.16  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 112.124.55.16    -j ACCEPT



#local network request
$IPTABLES -t filter -A INPUT -p tcp  -s 192.168.10.0/24    -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  -s 192.168.10.0/24     -j ACCEPT

#安骑士Agent

$IPTABLES -t filter -A INPUT  -s 125.65.81.0/24  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -d 125.65.81.0/24 -j ACCEPT
$IPTABLES -t filter -A INPUT  -s 140.205.140.0/24  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -d 140.205.140.0/24 -j ACCEPT
$IPTABLES -t filter -A INPUT  -s 106.11.68.0/24 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -d 106.11.68.0/24 -j ACCEPT
$IPTABLES -t filter -A INPUT  -s 110.173.196.0/24 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -d 110.173.196.0/24 -j ACCEPT
$IPTABLES -t filter -A INPUT  -s 100.100.25.0/24 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -d 100.100.25.0/24 -j ACCEPT

#DNS 
$IPTABLES -t filter -A INPUT -p udp --sport 53 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp  --dport 53 -j ACCEPT



#limit syn foold
$IPTABLES -t filter  -A INPUT -p tcp --syn -m limit --limit 2048/s -j ACCEPT

#testmail
$IPTABLES -t filter -A INPUT -p tcp --sport 25 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --dport 25 -j ACCEPT

#daifa10  mysql
$IPTABLES -t filter -A INPUT  -p tcp -s 120.26.75.10 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 120.26.75.10 --sport 40003 -j ACCEPT

#aliyun mysql slave
$IPTABLES -t filter -A INPUT  -p tcp -s 114.55.40.178 --dport 40003  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -d 114.55.40.178 --sport 40003 -j ACCEPT


#rsync
$IPTABLES -t filter -A INPUT  -p tcp  --dport 40004 -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp --sport 40004  -j ACCEPT


##############Iptables save and restart
echo "Iptables save and restart ..."
/etc/init.d/iptables  save
/etc/init.d/iptables restart

