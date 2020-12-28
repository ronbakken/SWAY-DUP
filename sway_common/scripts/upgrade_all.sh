#!/bin/sh
set -x
cd "$DIR"
cd ../..

sudo apt update
sudo apt upgrade -y

pub global activate protoc_plugin
pub global activate stagehand

git pull

cd inf_server_api
pub get
pub upgrade
cd ..

cd sway_common
pub get
pub upgrade
cd ..

cd sway_config
git pull
pub get
pub upgrade
cd ..
