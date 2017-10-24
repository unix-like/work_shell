#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/go2.cn/edu.go2.cn/htdocs
BACK_DIR=/gotwo_data/sites/go2.cn/edu.go2.cn/backup
GIT_DIR=/gotwo_data/probject_code/edu.go2.cn
#check config
grep config $1 && echo "请注意，更新包含配置文件！！！" && exit


#pull code
su - appdeploy  -c "cd $GIT_DIR &&  git pull origin 0.1.0"

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

        if [ ! -d `dirname ${WEB_DIR}/${i}` ]; then
                mkdir -pv `dirname ${WEB_DIR}/${i}`
        fi

	cp -v $GIT_DIR/$i $WEB_DIR/$i
done

echo
echo "update code complete!!!"

