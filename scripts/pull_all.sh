#!/bin/sh
set -x

cd ~/infclient
git pull

cd ~/infserver
git pull

cd ~/infcommon
git pull
