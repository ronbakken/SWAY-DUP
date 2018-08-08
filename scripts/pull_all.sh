#!/bin/sh
set -x

cd ~/infclient
git pull --recurse-submodules
git submodule update --init

cd ~/infserver
git pull --recurse-submodules
git submodule update --init

cd ~/infcommon
git pull --recurse-submodules
git submodule update --init
