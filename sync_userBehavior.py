# -*- coding:utf-8 -*-
'''
test query data, export and import from mongodb 
'''

import sys,os,subprocess
from pymongo import MongoClient
from pymongo import DESCENDING
from datetime import *
import time

ISOTIMEFORMAT='%Y-%m-%d %X'
MONGOEXPORT='/usr/bin/mongoexport -d %s -c %s -o %s '
MONGOIMPORT='/usr/bin/mongoimport -d %s -c %s --upsert %s '

trace_file='/gotwo_data/scripts/dump.trc'

#global dump_dir='/gotwo_data/backup/mongodb/'

def str2isotime(time_string):
    cur_time=time.strptime(time_string,ISOTIMEFORMAT)
    return datetime.utcfromtimestamp(time.mktime(cur_time))

def initMongo(mongo_host,mongo_port,db_name):
    client = MongoClient(mongo_host,mongo_port)
    return client[db_name]

def get_last_row(collection):
        rows=collection.find({},{"_id":1}).sort([("timestamp",DESCENDING)]).limit(1)
        return [row for row in rows]

def record_row_pos(collection,row,fname):
        print "%s %s %s " %(collection,row,fname)
        f=file(fname,'a')
        f.write("%s=%s\n" % (collection,row))
        f.close()

def dump_collection(db,collection):
	dump_dir='/gotwo_data/backup/mongodb/%s_all' %  date.today()
	if os.path.isdir(dump_dir) is False:
	   os.mkdir(dump_dir)

	cmd=MONGOEXPORT % (db,collection,'%s/%s.dat' % (dump_dir,collection) )
	subprocess.call(cmd, shell=True)
	return 0

        row=get_last_row(db[collection])
        fname=trace_file
        if len(row) !=0:
           print "the length is %s"  % (len(row))
           record_row_pos(collection,row[0],fname)
           cmd=MONGOEXPORT % (db.name,collection,'%s/%s.dat' % (dump_dir,collection) )
           print cmd
           subprocess.call(cmd, shell=True)

def dump_collection_inc(db,collection,condition):
	dump_dir='/gotwo_data/backup/mongodb/%s_inc' %  date.today()
        if os.path.isdir(dump_dir) is False:
           os.mkdir(dump_dir)

	row=get_last_row(db[collection])
	fname=trace_file + '.%s' % date.today()
	record_row_pos(collection,row[0],fname)
	cmd=MONGOEXPORT % (db.name,collection,'%s/%s.dat' % (dump_dir,collection) ) + " -q '%s'" % condition
        print cmd
        subprocess.call(cmd, shell=True)

def get_beg_pos():
	col_beg_pos={}
	with open(trace_file) as f:
	   for line in f:
	      line=line.replace("'",'"')
	      #print line
	      separator=line.find('=')
	      coll_name=line[0:separator]
	      coll_key=line[separator+1:][2:7]
	      coll_val=line[separator+1:][9:-2]
	      col_beg_pos[coll_name]={coll_key:coll_val}
	      #print coll_val
	      #print (coll_name,coll_key,coll_val)
	#print col_beg_pos
	return col_beg_pos


def main():
        mongo_host="127.0.0.1"
        mongo_port=27017
        db_name="userBehavior_%s" % date.today().strftime('%Y%m')
        #print db_name
        #sys.exit(0)

        db=initMongo(mongo_host, mongo_port, db_name)
        #print db.name
        collection_names=db.collection_names()
    
        #for col_name in collection_names:
        #        dump_collection(db,col_name)
	coll_beg_pos=get_beg_pos()
	for coll_name in coll_beg_pos.keys():
	    #condition='{"_id":{$gte:%s}}' % (coll_beg_pos[coll_name].get('"_id"') )
	    condition='{"_id":{$gte:%s},{"params":{ $exists:false }}}' % (coll_beg_pos[coll_name].get('"_id"') )
	    #print condition
	    dump_collection_inc(db,coll_name,condition)
        
        #db_name="firewall"

	#dump_collection_inc(db,'httpRequest_2mm')
    
    #pass

def black_list():
	db_name="firewall"
	coll_name="blacklist"
	dump_collection(db_name,coll_name)

if __name__ == '__main__':
        main()
	black_list()

