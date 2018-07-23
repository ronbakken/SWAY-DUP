#!/bin/sh

cd ~/infcommon/
git pull

cd config
pub get
dart bin/main.dart
git add *
git commit -m "Update config"
cd ..

git push
git status


cd ~/infclient
git pull

cp ~/infcommon/config/config.bin infapp/assets/config.bin
git add *
git commit -m "Update config"

git push
git status

cd ~/infcommon/scripts
