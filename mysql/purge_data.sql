
create table image_info_201611 like image_info;

select count(1) from image_info where create_time < '2016-12-01 00:00:00';
+----------+
| count(1) |
+----------+
|  5177020 |
+----------+

mysqldump -t --single-transaction --where="create_time < '2016-12-01 00:00:00'" publish image_info > image_info_201611.sql

sed -i 's/image_info/image_info_201611/g' image_info_201611.sql

mysql publish  < image_info_201611.sql

select count(1) from image_info_201611；
+----------+
| count(1) |
+----------+
|  5177020 |
+----------+


delete from image_info_201701 where create_time >= '2017-02-01 00:00:00';

select count(1) from image_info_201611 where create_time < '2016-12-01 00:00:00';





