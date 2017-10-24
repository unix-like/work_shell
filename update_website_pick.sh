#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/pick.ximgs.net/htdocs
BACK_DIR=/gotwo_data/sites/pick.ximgs.net/backup
GIT_DIR=/gotwo_data/probject_code/2mm_picking_tool

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

    cp -rv $GIT_DIR/errors/*  $WEB_DIR/errors/
    cp -rv $GIT_DIR/fonts/*  $WEB_DIR/fonts/
    cp -rv $GIT_DIR/images/* $WEB_DIR/images/
    cp -rv $GIT_DIR/index.php  $WEB_DIR/index.php
    cp -rv $GIT_DIR/plugins/* $WEB_DIR/plugins/
    cp -rv $GIT_DIR/scripts/* $WEB_DIR/scripts/
    cp -rv $GIT_DIR/styles/* $WEB_DIR/styles/
    cp -rv $GIT_DIR/system/* $WEB_DIR/system/
    cp -rv $GIT_DIR/upload/* $WEB_DIR/upload/
    cp -rv $GIT_DIR/application/controllers/* $WEB_DIR/application/controllers/
    cp -rv $GIT_DIR/application/errors/* $WEB_DIR/application/errors/
    cp -rv $GIT_DIR/application/index.html $WEB_DIR/application/index.html
    cp -rv $GIT_DIR/application/libraries/* $WEB_DIR/application/libraries/
    cp -rv $GIT_DIR/application/models/* $WEB_DIR/application/models/
    cp -rv $GIT_DIR/application/templates/* $WEB_DIR/application/templates/

fi
