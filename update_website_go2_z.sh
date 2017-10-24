#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/go2.cn/z.go2.cn/htdocs
BACK_DIR=/gotwo_data/sites/go2.cn/z.go2.cn/backup/`date +%F_%H-%M`
GIT_DIR=/gotwo_data/probject_code/z.go2.cn

#check config

#grep constants $1 && echo "请注意，更新包含配置文件！！！" && exit

#pull code
su - appdeploy  -c "cd $GIT_DIR && git checkout master &&  git pull origin master"

#backup code
echo "begin backup...."

if [ $1 ]; then
    for j in `cat $1`
       do
       if [ ! -d `dirname ${BACK_DIR}/${j}` ]; then
           mkdir -p `dirname ${BACK_DIR}/${j}`
       fi

       cp -vr  $WEB_DIR/$j $BACK_DIR/$j
    done

else

    rsync -a --exclude 'runtime'  --exclude 'upload' --exclude 'backend' $WEB_DIR $BACK_DIR

fi


echo " backup end...."

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

#    cp -r $GIT_DIR/frontend/components/*   $WEB_DIR/frontend/components/ 
#    cp -r $GIT_DIR/frontend/controllers/*  $WEB_DIR/frontend/controllers/
#    cp -r $GIT_DIR/frontend/models/*       $WEB_DIR/frontend/models/
#    cp -r $GIT_DIR/frontend/views/*        $WEB_DIR/frontend/views/
#    cp -r $GIT_DIR/frontend/web/errors/*   $WEB_DIR/frontend/web/errors/
#    cp -r $GIT_DIR/frontend/web/fonts/*    $WEB_DIR/frontend/web/fonts/
#    cp -r $GIT_DIR/frontend/web/images/*   $WEB_DIR/frontend/web/images/
#    cp -r $GIT_DIR/frontend/web/scripts/*  $WEB_DIR/frontend/web/scripts/
#    cp -r $GIT_DIR/frontend/web/styles/*   $WEB_DIR/frontend/web/styles/
#    cp -r $GIT_DIR/console/controllers/*   $WEB_DIR/console/controllers/
#    cp -r $GIT_DIR/console/models/*        $WEB_DIR/console/models/
#    cp -r $GIT_DIR/console/components/*    $WEB_DIR/console/components/
#    cp -r $GIT_DIR/frontend/config/main.php    $WEB_DIR/frontend/config/main.php
#    cp -r $GIT_DIR/frontend/config/params.php    $WEB_DIR/frontend/config/params.php
#    cp -r $GIT_DIR/vendor/smarty/smarty/libs/plugins/*    $WEB_DIR/vendor/smarty/smarty/libs/plugins/

echo "不支持"

fi


echo " update success...."


