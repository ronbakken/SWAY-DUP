#!/bin/sh
set -x


# pub global activate protoc_plugin


cd ~/infcommon/
git pull --recurse-submodules
git add *
git commit -m "Update protobuf"

cd protobuf
protoc --dart_out=./dart/ *.proto
protoc --csharp_out=./cs/ *.proto
cd dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
cd ..
git add *
cd ../config
cp ../protobuf/dart/config_*.dart lib/protobuf/
cp ../protobuf/dart/data_*.dart lib/protobuf/
cp ../protobuf/dart/enum_*.dart lib/protobuf/
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

cp ~/infcommon/protobuf/dart/*.dart infapp/lib/protobuf/
git add *
git commit -m "Compile protobuf"

git push
git status


cd ~/infserver
git pull --recurse-submodules
git add *
git commit -m "Update protobuf"

cp ~/infcommon/protobuf/dart/*.dart api/lib/protobuf/
git add *
git commit -m "Compile protobuf"

git push
git status


cd ~/infcommon/scripts
