#/bin/bash

MYSQL=/gotwo_data/Application/mysql/bin/mysql

#for DATABASE in db_go2 db_3e3e;
for DATABASE in db_go2;
     do
    $MYSQL -uroot -pXcQVr8CmHhs4FVN2 << EOF
use $DATABASE;
INSERT INTO user_state_count (dt,dt_num,type,state,create_date,num) SELECT * FROM (SELECT adddate(curdate(), INTERVAL - 1 DAY) dt,date_format(adddate(curdate(), INTERVAL - 1 DAY),'%Y%m%d') dt_num,type,state,date(create_time) create_date,count(1) num FROM user u WHERE date(create_time) <= adddate(curdate(), INTERVAL - 1 DAY) and not EXISTS(select 1 from supplier s where s.user_id=u.id and s.market_id>=1000) AND create_time IS NOT NULL GROUP BY type,state,date(create_time) ) a;
EOF

done

