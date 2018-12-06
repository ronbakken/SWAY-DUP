#!/bin/sh
set -x


cd ~/inf_config
git pull
git add *
git commit -m "Update"

pub get
dart bin/compile_config.dart
git add *
git commit -m "Build config"

git push
git status


cd ~/infclient
git pull
git add *
git commit -m "Update"

cp ~/inf_config/config/config.bin assets/config.bin
git add *
git commit -m "Build config"

git push
git status


cd ~/infserver
git pull --recurse-submodules
git add *
git commit -m "Update"

cp ~/inf_config/config/config_server.bin inf_server_api/assets/config_server.bin
git add *
git commit -m "Build config"

git push
git status


cd ~/inf_common/scripts
