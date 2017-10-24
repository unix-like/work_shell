#!/usr/bin/python
#coding:UTF-8

import sys,os,subprocess,time
from datetime import datetime,date,timedelta
from pymongo import MongoClient

def is_first_day_of_month():
	today=time.localtime(time.time())
	
	if today.tm_mday == 1:
		return True
	else:
		return False

class DumpData(object):
        def __init__(self,host,port):
                self.client=MongoClient(host,port)
                self.db_name=''
                self.col_list=[]

        def set_col_name(self,num):
                self.db_name='userBehavior_' + num

        def get_col_names(self):
                #print self.db_name
                return self.client.get_database(self.db_name).collection_names()

        def dump_collection(self,timestamp=None):
		dump_dir='/gotwo_data/backup/mongodb/%s_inc/' %  date.today()

                if os.path.isdir(dump_dir) is False:
                        os.mkdir(dump_dir)

                MONGOEXPORT='''/usr/bin/mongoexport -d %s -c %s -o %s%s.dat -q '{"timestamp":{$gte:ISODate("%s")}}' '''
                self.col_list=self.client.get_database(self.db_name).collection_names()
                #if not timestamp:
                for col_name in self.col_list:
                        dump_cmd=MONGOEXPORT % (self.db_name,col_name,dump_dir,col_name,timestamp)
                        print dump_cmd
                        subprocess.call(dump_cmd, shell=True)

def main():
        today= datetime.now()
        yesterday=today - timedelta(hours=48)

        timestamp=yesterday.strftime("%Y-%m-%dT16:00:00.000Z")
        #print today.strftime("%d")
        dump_data=DumpData('127.0.0.1',27017)
	if is_first_day_of_month():
		dump_data.set_col_name( yesterday.strftime("%Y%m") )
	else:
		dump_data.set_col_name( today.strftime("%Y%m") )
        #dump_data.set_col_name( today.strftime("%Y%m") )
        dump_data.dump_collection(timestamp)


if __name__ == '__main__':
        main()
