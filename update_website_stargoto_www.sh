#!/bin/bash

#desc:update web site

#auther:xiaoxing
#date:2015-12-14


WEB_DIR=/gotwo_data/sites/stargoto.com/www.stargoto.com/htdocs
BACK_DIR=/gotwo_data/sites/stargoto.com/www.stargoto.com/backup
GIT_DIR=/gotwo_data/probject_code/stargoto

#pull code
su - appdeploy  -c "cd $GIT_DIR &&  git pull origin 0.1.0"

echo
echo "pull code complete!!!"

#backup code
rsync -av $WEB_DIR $BACK_DIR/`date +%F_%H-%M`

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

