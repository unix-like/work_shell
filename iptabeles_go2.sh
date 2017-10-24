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
$IPTABLES -t filter -P FORWARD DROPNEW

### load connection-tracking modules
$MODPROBE ip_conntrack
$MODPROBE iptable_nat
$MODPROBE ip_conntrack_ftp
$MODPROBE ip_nat_ftp

########IP4
echo "[+] Setting up OUTPUT chain..."

$IPTABLES -t filter -A INPUT -i lo -j ACCEPT
$IPTABLES -t filter -A OUTPUT -o lo -j ACCEPT

#limit ping
$IPTABLES -t filter -A INPUT -p icmp  -m state --state NEW,ESTABLISHED,RELATED  -m icmp --icmp-type echo-request -m limit --limit 30/second  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#local network request
$IPTABLES -t filter -A INPUT  -s 192.168.10.0/24    -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -d 192.168.10.0/24     -j ACCEPT

#sha he bao IP
$IPTABLES -t filter -A INPUT  -s 125.64.19.0/24    -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -d 125.64.19.0/24   -j ACCEPT

$IPTABLES -t filter -A INPUT  -s 125.64.15.0/24    -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -d 125.64.15.0/24   -j ACCEPT
#SSH port
$IPTABLES -t filter -A INPUT -p tcp  --dport 40001 -m state --state NEW,ESTABLISHED  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --sport 40001 -m state --state ESTABLISHED -j ACCEPT

#VPN port
$IPTABLES -t filter -A INPUT -p tcp  --dport 41194 -m state --state NEW,ESTABLISHED  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp  --sport 41194 -m state --state ESTABLISHED -j ACCEPT


#web
$IPTABLES -t filter -A INPUT -p tcp -m state --state NEW,ESTABLISHED --dport 80 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p tcp -m state --state ESTABLISHED --sport  80 -j ACCEPT

#dns
$IPTABLES -t filter -A INPUT -p udp -m state --state ESTABLISHED  --sport 53 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp -m state --state NEW,ESTABLISHED --dport 53 -j ACCEPT

#ntp
$IPTABLES -t filter -A INPUT  -p udp -m state --state ESTABLISHED --sport 123  -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp -m state --state NEW,ESTABLISHED --dport 123  -j ACCEPT

#TAOBAO api
$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.160.248 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.160.248 -m state --state NEW,ESTABLISHED -j ACCEPT

$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 112.124.55.16 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 112.124.55.16 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.170.14 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.170.14 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.170.146 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.170.146 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.176.114 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.176.114 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.176.170 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.176.170 -m state --state NEW,ESTABLISHED -j ACCEPT


$IPTABLES -t filter -A INPUT  -p tcp -m tcp -s 121.199.176.178 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPTABLES -t filter -A OUTPUT  -p tcp -m tcp -d 121.199.176.178 -m state --state NEW,ESTABLISHED -j ACCEPT



#limit (syn foold)
$IPTABLES -t filter  -A INPUT -p tcp --syn -m limit --limit 2048/s -j ACCEPT

#openvpn ip snat
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o em2 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o em3 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o em4 -j MASQUERADE

##############Iptables save and restart 
echo "Iptables save and restart ..."
/etc/init.d/iptables  save
/etc/init.d/iptables restart
