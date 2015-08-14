#!/bin/bash

#a script to create dex file for Matata on my computer
className="DexLoaderGetSMS"

mv /home/admin/Programming/project/proAndroid/Matata/app/build/intermediates/classes/debug/project/richthofen911/matata/$className.class /home/admin/Programming/project/proAndroid/Matata/app/src/main/java/project/richthofen911/matata/
cd /home/admin/Programming/project/proAndroid/Matata/app/src/main/java/
jar cvf $className.jar project/richthofen911/matata/$className.class
/home/admin/Programming/sdk/android-linux-sdk/build-tools/22.0.1/dx --dex --output=$className.dex $className.jar
rm /home/admin/Programming/project/proAndroid/Matata/app/src/main/java/project/richthofen911/matata/$className.class
rm /home/admin/Programming/project/proAndroid/Matata/app/src/main/java/project/richthofen911/matata/$className.java
rm /home/admin/Programming/project/proAndroid/Matata/app/src/main/java/$className.jar

