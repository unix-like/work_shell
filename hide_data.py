# -*- coding: utf-8 -*-
import sys
import pymysql.cursors

SQL_LIST=[
'''select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME 
    from COLUMNS 
    where (COLUMN_COMMENT like '%电话%' or COLUMN_NAME='mobile')  
    and TABLE_SCHEMA in ('db_go2','db_2mm','db_3e3e','db_bag8','db_sys','db_ad','go2plus_photography');
''',
'''select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME 
    from COLUMNS 
    where (COLUMN_COMMENT like '%邮箱%' or COLUMN_NAME='email') 
    and TABLE_SCHEMA in ('db_go2','db_2mm','db_3e3e','db_bag8','db_sys','db_ad','go2plus_photography');
'''
]


def hide_data(db_host,db_port,sql):
    config = {
         'host':db_host,
         'port':int(db_port),
         'user':'root',
         'password':'leweisa',
         'db':'information_schema',
         'charset':'utf8',
         'cursorclass':pymysql.cursors.DictCursor,
         }
     
    # Connect to the database
    conn = pymysql.connect(**config)    


    try:
    	with conn.cursor() as cursor:
    		cursor.execute(sql)
    		result=cursor.fetchall()
    		for row in result:
    			sql="update %s.%s set %s = '******' where %s is not null;" % (row['TABLE_SCHEMA'],row['TABLE_NAME'],row['COLUMN_NAME'],row['COLUMN_NAME'])
    			#cursor.execute(sql)
    			#res=cursor.fetchall()
    			print("Hide private data for TABLE %s in DB %s" % ( row['TABLE_NAME'],row['TABLE_SCHEMA']) )    

    			cursor.execute(sql)
    			#print(sql)
    			conn.commit()    

    		#print(result)
    except Exception, e:
    	print str(e)
    finally:
    	conn.close()    

    print("Hide private data done !!")

def main():

	(db_host,db_port)=(sys.argv[1],sys.argv[2])
	for sql in SQL_LIST:
		print("SQL statement is:\n %s" % sql)
		hide_data(db_host, db_port,sql)

if __name__ == '__main__':
	main()


