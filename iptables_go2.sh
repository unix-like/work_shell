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


#MYSQL
#$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 125.64.19.222 --dport 40003 -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 125.64.19.222 --sport 40003 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 125.64.19.222  -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 125.64.19.222 -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 10.116.200.239 --dport 40003 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 10.116.200.239 --sport 40003 -m state --state ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 10.168.141.115 --dport 40003 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 10.168.141.115 --sport 40003 -m state --state ESTABLISHED -j ACCEPT
#zabbix
$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 125.64.15.29 --dport 10050 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 125.64.15.29 --sport 10050 -m state --state ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 125.64.15.29 --sport 10051 -m state --state ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 125.64.15.29 --dport 10051 -m state --state NEW,ESTABLISHED -j ACCEPT


#ping limit
$IPTABLES -t filter -A INPUT -p icmp  -m state --state NEW,ESTABLISHED,RELATED  -m icmp --icmp-type echo-request    -m limit --limit 10/second  -j ACCEPT
$IPTABLES -t filter -A INPUT -p icmp  -m state --state NEW,ESTABLISHED,RELATED  -m icmp --icmp-type echo-reply    -m limit --limit 10/second  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED    -j ACCEPT

#SSH PORT
$IPTABLES -t filter -A INPUT -p tcp  --dport 40001 -m state --state NEW,ESTABLISHED  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --sport 40001 -m state --state ESTABLISHED -j ACCEPT

#local network request
#$IPTABLES -t filter -A INPUT -p tcp -m state --state NEW,ESTABLISHED -s 192.168.10.0/24    -j ACCEPT
#$IPTABLES -t filter -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -d 192.168.10.0/24     -j ACCEPT

#DNS 
$IPTABLES -t filter -A INPUT -p udp -m state --state ESTABLISHED  --sport 53 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp -m state --state NEW,ESTABLISHED --dport 53 -j ACCEPT


#NTP TIME SYNC
$IPTABLES -t filter -A INPUT  -p udp -m state --state ESTABLISHED --sport 123  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp -m state --state NEW,ESTABLISHED --dport 123  -j ACCEPT

#limit syn foold
$IPTABLES -t filter  -A INPUT -p tcp --syn -m limit --limit 2048/s -j ACCEPT

##############Iptables save and restart
echo "Iptables save and restart ..."
/etc/init.d/iptables  save
/etc/init.d/iptables restart

