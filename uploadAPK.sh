#!/bin/bash

# this is used to replace the old file with a new one (same name)
# copy & paste the file to the same directory where the target file is, and exec in commandline "./uploadAPK.sh file_name" 

FILE_NAME=$1

# remove the old file
sshpass -p "f264fecd50999999" ssh root@159.203.15.175 "rm /var/www/html/apps/$FILE_NAME"
# upload the new file
sshpass -p "f264fecd50999999" scp $FILE_NAME root@159.203.15.175:/var/www/html/apps/
