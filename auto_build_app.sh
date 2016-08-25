#!/bin/bash

cd /home/admin/Programming/ap1/Proximity_dev/app/src/main/res/values/
# change bundleID
xmlstarlet ed -L -u "/resources/string[@name='idbundle']" -v $1 strings.xml
# change app_name
xmlstarlet ed -L -u "/resources/string[@name='app_name']" -v $2 strings.xml

# cd to the project's root directory
cd /home/admin/Programming/ap1/Proximity_dev/
# delete the old apk file
rm ./app/build/outputs/apk/app-debug.apk
# build a new debug version apk
./gradlew assembleDebug
# cp the new built apk to my target directory
cp ./app/build/outputs/apk/app-debug.apk /home/admin/Proximity_derivative/$2.apk

# cd to my target directory and upload to the server through sftp
cd /home/admin/Proximity_derivative
sshpass -p f264fecd50999999 sftp root@159.203.3.82:/var/www/html/apps << !
put $2.apk
bye
!
