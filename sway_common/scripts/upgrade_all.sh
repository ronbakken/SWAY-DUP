#!/bin/sh
set -x
cd "$DIR"

sudo apt update
sudo apt upgrade -y

pub global activate protoc_plugin
pub global activate stagehand

cd ~/inf_mobile_app
git pull

cd ~/inf_server
git pull
cd inf_server_api
pub get
pub upgrade

cd ~/inf_common
git pull
pub get
pub upgrade

cd ~/inf_config
git pull
pub get
pub upgrade

cd ~/inf_app
git pull
