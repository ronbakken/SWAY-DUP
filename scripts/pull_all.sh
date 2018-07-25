#!/bin/sh
set -x

cd ~/infclient
git pull --recurse-submodules

cd ~/infserver
git pull --recurse-submodules

cd ~/infcommon
git pull --recurse-submodules
