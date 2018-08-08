#!/bin/sh
set -x


cd ~/infcommon
git pull --recurse-submodules
git add *
git commit -m "Update"

cd config
# pub get
# pub upgrade
dart bin/main.dart
git add *
git commit -m "Build config"
cd ..

git push
git status


cd ~/infclient
git pull --recurse-submodules
git add *
git commit -m "Update"

cp ~/infcommon/config/config.bin infapp/assets/config.bin
git add *
git commit -m "Build config"

git push
git status


cd ~/infserver
git pull --recurse-submodules
git add *
git commit -m "Update"

cp ~/infcommon/config/config_server.bin api/assets/config_server.bin
git add *
git commit -m "Build config"

git push
git status


cd ~/infcommon/scripts
