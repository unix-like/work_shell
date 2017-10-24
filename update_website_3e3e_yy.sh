#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/3e3e.cn/yy.3e3e.cn/htdocs
BACK_DIR=/gotwo_data/sites/3e3e.cn/yy.3e3e.cn/backup
GIT_DIR=/gotwo_data/probject_code/django.3e3e.cn

#check config
#grep config $1 && echo "请注意，更新包含配置文件！！！" && exit


#pull code
su - appdeploy  -c "cd $GIT_DIR &&  git pull origin master"

echo
echo "pull code complete!!!"

#backup code
echo "backup begin........"

rsync -a $WEB_DIR $BACK_DIR/`date +%F_%H-%M`

echo
echo "backup code complete!!!"

#update code
if [ $1 ]; then   
    for i in `cat $1`
       do 
       if [ ! -d `dirname ${WEB_DIR}/${i}` ]; then
           mkdir -pv `dirname ${WEB_DIR}/${i}`
        fi

       cp -vr  $GIT_DIR/$i $WEB_DIR/$i
    done

else

    cp -rv $GIT_DIR/images/*  $WEB_DIR/images/
    cp -rv $GIT_DIR/styles/*  $WEB_DIR/styles/
    cp -rv $GIT_DIR/scripts/* $WEB_DIR/scripts/
    cp -rv $GIT_DIR/application/controllers/*  $WEB_DIR/application/controllers/
    cp -rv $GIT_DIR/application/libraries/* $WEB_DIR/application/libraries/
    cp -rv $GIT_DIR/application/models/* $WEB_DIR/application/models/
    cp -rv $GIT_DIR/application/templates/* $WEB_DIR/application/templates/
    cp -rv $GIT_DIR/application/config/function.php $WEB_DIR/application/config/function.php
    cp -rv $GIT_DIR/application/config/routes.php $WEB_DIR/application/config/routes.php
    cp -rv $GIT_DIR/application/config/permission.php $WEB_DIR/application/config/permission.php

fi

echo
echo "update code complete!!!"

