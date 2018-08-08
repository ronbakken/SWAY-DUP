#!/bin/sh
set -x

apt update
apt upgrade

pub global activate protoc_plugin

cd ~/infclient
git pull --recurse-submodules
git submodule update --init

cd ~/infserver
git pull --recurse-submodules
git submodule update --init
cd api
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
