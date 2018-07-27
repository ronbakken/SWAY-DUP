#!/bin/sh
set -x


cd ~/infcommon/
git pull --recurse-submodules
git add *
git commit -m "Update protobuf"

cd protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
git add *
cd ../config
cp ../protobuf/*.dart lib/
git add *
# cd ../api
# cp ../protobuf/*.dart lib/
# git add *
cd ..
git commit -m "Compile protobuf"

git push
git status


cd ~/infclient
git pull --recurse-submodules
git add *
git commit -m "Update protobuf"

cp ~/infcommon/protobuf/*.dart infapp/lib/network/
git add *
git commit -m "Compile protobuf"

git push
git status


cd ~/infserver
git pull --recurse-submodules
git add *
git commit -m "Update protobuf"

cp ~/infcommon/protobuf/*.dart api/lib/
git add *
git commit -m "Compile protobuf"

git push
git status


cd ~/infcommon/scripts
