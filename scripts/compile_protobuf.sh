#!/bin/sh

cd ~/infcommon/
git pull

cd protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
git add *
cd ../config
cp ../protobuf/*.dart lib/
git add *
cd ../api
cp ../protobuf/*.dart lib/
git add *
cd ..
git commit -m "Update protobuf"

git push
git status

cd ~/infclient
git pull

cp ~/infcommon/protobuf/*.dart infapp/lib/
git add *
git commit -m "Update protobuf"

git push
git status

cd ~/infcommon/scripts
