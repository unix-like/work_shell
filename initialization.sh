#/bin/bash

USER1=user1
USER2=user2
USER3=user3

PASSWORD=www.wwww2321

####add user####
for user in {$USER1,$USER2,$USER3};do
    useradd $user
    echo "$PASSWORD" | passwd --stdin $user
    
    echo "$user    ALL=(ALL)    ALL" >> /etc/sudoers
done


####limit####

echo "*    soft    nofile     65535"  >> /etc/security/limits.conf
echo "*    hard    nofile     65535"  >> /etc/security/limits.conf

sed -i 's/1024/65535/' /etc/security/limits.d/90-nproc.conf


####ssh####
sed -i 's/#MaxAuthTries 6/MaxAuthTries 6/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 40001/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

####selinux####
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

