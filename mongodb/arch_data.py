#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
archive the old data in userBehavior to new db
'''


import sys,os
from multiprocessing import Process
from pymongo import MongoClient
from pymongo import DESCENDING
from datetime import *
import time
reload(sys)
sys.setdefaultencoding('utf8')


def initMongo(mongo_host,mongo_port,db_name):
    client = MongoClient(mongo_host,mongo_port)
    return client[db_name]

def archData(newdb_name,col_name,start_time,end_time):
	mongo_host="127.0.0.1"
	mongo_port=27017
	db_name="userBehavior"

	db=initMongo(mongo_host, mongo_port, db_name)
	newdb=initMongo(mongo_host, mongo_port, newdb_name)

	print "start archive collection %s history data ...\n" % col_name

	rows= ( db.get_collection(col_name).find({'timestamp':{'$gte':start_time,'$lte':end_time}}) )
	i=0

	for row in rows:
		ipItem=db.get_collection('iplocation').find_one({'ip':row['ip']})
		#.findOne({'ip':row['ip']});
		if ipItem:
			#print ipItem['_id']
			#print ipItem['city']
			#print row['ip']

			row['country']=ipItem['country']
			row['area']=ipItem['area']
			row['region']=ipItem['region']
			row['city']=ipItem['city']
			row['isp']=ipItem['isp']

			newdb.get_collection(col_name).delete_one({"_id":row['_id']})
			newdb.get_collection(col_name).insert_one(row)
			db.get_collection(col_name).delete_one({"_id":row['_id']})

			#i+=1
			#if i==10: break
	print "Finish archive collection %s history data ...\n" % col_name

def main():
	ISOTIMEFORMAT='%Y-%m-%d %X'
	start_time=datetime.strptime('2016-10-01 00:00:00',ISOTIMEFORMAT)
	end_time=datetime.strptime('2016-11-01 00:00:00',ISOTIMEFORMAT)
	collections=['httpRequest_go2','httpRequest_go2plus','httpRequest_2mm','httpRequest_3e3e','httpRequest_bag8','httpRequest_photography']
	col_name='httpRequest_go2'
	newdb_name='userBehavior_201610'

	#for col in collections:
	#	print "archive collection %s history data ..." % col
	#	archData(newdb_name, col, start_time, end_time)

	process_list = []

	for col in collections:
		p = Process(target=archData,args=(newdb_name, col, start_time, end_time))
		p.start()
		process_list.append(p)

	for proc in process_list:
		proc.join()


if __name__ == '__main__':
	main()

