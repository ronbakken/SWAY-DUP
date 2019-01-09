#!/bin/sh
set -x
cd "$DIR"

cd ~/inf_mobile_app
git pull

cd ~/inf_server
git pull

cd ~/inf_common
git pull

cd ~/inf_config
git pull

cd ~/inf_app
git pull
