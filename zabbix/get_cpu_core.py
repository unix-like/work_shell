#!/usr/bin/env python
#coding=utf8

import os
import re 
import json
devices = []
cpu_info=open('/proc/cpuinfo','r').readlines()
for i in cpu_info:
 if re.match('proc',i):
  [p,u]=i.strip("\r\n").split(':')
  devices += [{'{#CORE_NUM}':u.lstrip()}]
print json.dumps({'data':devices},sort_keys=True,indent=7,separators=(',',':'))
#print json.dumps({'data':devices})
#print  devices

