#!/bin/sh
set -x

sudo apt update
sudo apt upgrade

pub global activate protoc_plugin
pub global activate stagehand

cd ~/infclient
git pull --recurse-submodules
git submodule update --init

cd ~/infserver
git pull --recurse-submodules
git submodule update --init
cd inf_server_api
pub get
pub upgrade
cd ../dart-oauth1
pub get
pub upgrade
cd ../dospace
pub get
pub upgrade
cd ../sqljocky5
pub get
pub upgrade
cd ../wstalk
pub get
pub upgrade

cd ~/infcommon
git pull --recurse-submodules
git submodule update --init
cd config
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
