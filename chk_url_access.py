import sys,os,time,subprocess,smtplib
from email.mime.text import MIMEText

log_file='/gotwo_data/logs/nginx/www.go2.cn.access.log'

interval=30
access_threshold=40
mail_list=['yunwei@stargoto.com']

acc_top_one={}
access_cnt={}

sec_access_cnt={}
inc_access_cnt={}

def send_mail(to_list, sub,content):
   mail_host = "smtp.exmail.qq.com"
   mail_user = "sa@go2.cn"
   mail_pass = "WfQRTzIeSQx5kC7o"
   mail_postfix="go2.cn"

   me = mail_user + "<"+mail_user+"@"+mail_postfix+">"
   msg = MIMEText(content, _charset="utf-8")
   msg['Subject'] = sub
   msg['From'] = me
   msg['To'] = ";".join(to_list)
   try:
           send_smtp = smtplib.SMTP()
           send_smtp.connect(mail_host)
           send_smtp.login(mail_user, mail_pass)
           send_smtp.sendmail(me, to_list, msg.as_string())
           send_smtp.close()
           return True
   except Exception, e:
           print str(e)
           return False

def exec_cmd(cmd):
    p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
    output= p.stdout.read()
    return output

def url_access_stats():
    cmd="awk '{print $1}' %s  |sort |uniq -c |sort -nrk1 | head -20" % log_file
    return exec_cmd(cmd)

def set_access_info(text):
    lines=[ x.strip() for x in text.splitlines() ]

    for line in lines:
        item=line.split(' ')
        access_cnt[item[1]]=int(item[0])
    #print acc_top_one
    #print access_cnt

def calc_access_stats(text):
    lines=[ x.strip() for x in text.splitlines() ]

    for line in lines:
        item=line.split(' ')
        sec_access_cnt[item[1]]=int(item[0])

    #print sec_access_cnt

    for key in sec_access_cnt.keys():
        if key in access_cnt and float((sec_access_cnt[key]-access_cnt[key]) ) > 0:
           inc_access_cnt[key]=float( (sec_access_cnt[key]-access_cnt[key]) / interval )
   
    print inc_access_cnt

    clients=[ {key:inc_access_cnt[key]} for key in inc_access_cnt.keys() if inc_access_cnt[key] > access_threshold]
    msg='The client IP which access url per second more than %s times as below:\n' % access_threshold
    msg+='\n\n' +str(clients) + '\n\n'
      
    print msg

    if len(clients) > 0:
       msg+='\n'.join([ '/sbin/iptables -A INPUT -s %s -j DROP' % i.keys().pop() for i in clients ])
       msg+='\n\n' + exec_cmd('sar -n DEV 3 3 | egrep "em1|IFACE"')
       send_mail(mail_list,'www.go2.cn telcom website access statistics',msg)

def main():
    set_access_info( url_access_stats() )
    time.sleep(interval)
    calc_access_stats( url_access_stats() )

main()
