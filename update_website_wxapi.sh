#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/wxapi.ximgs.net/htdocs
BACK_DIR=/gotwo_data/sites/wxapi.ximgs.net/backup
GIT_DIR=/gotwo_data/probject_code/pub_to_weixin.go2.cn

#check config
#grep config $1 && echo "请注意，更新包含配置文件！！！" && exit


#pull code
su - appdeploy  -c "cd $GIT_DIR &&  git pull origin dev"

echo
echo "pull code complete!!!"

#backup code
echo "backup begin........"

rsync -a $WEB_DIR $BACK_DIR/`date +%F_%H-%M`

echo
echo "backup code complete!!!"

#update code
for i in `cat $1`
	do 
	cp -v $GIT_DIR/htdocs/$i $WEB_DIR/$i
done

echo
echo "update code complete!!!"

