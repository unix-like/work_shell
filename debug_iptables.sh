IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe

####IP4
echo "[+] Flushing existing $IPTABLES rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -t filter -P INPUT ACCEPT
$IPTABLES -t filter -P OUTPUT ACCEPT
$IPTABLES -t filter -P FORWARD ACCEPT
$IPTABLES -t filter -A INPUT -p udp -m state --state ESTABLISHED  --sport 53 -j ACCEPT
$IPTABLES -t filter -A OUTPUT -p udp -m state --state NEW,ESTABLISHED --dport 53 -j ACCEPT

##############Iptables save and restart
echo "Iptables save and restart ..."
/etc/init.d/iptables   save
/etc/init.d/iptables  restart

