#!/bin/sh
set -x


# pub global activate protoc_plugin
PROTOBUF_VERSION=$(cat ~/.pub-cache/global_packages/protoc_plugin/pubspec.lock | \
    awk '/protobuf:/{p=1;next}{if(p){print}}' | \
    awk '/version:/{print $2}' | \
    awk 'NR==1{print $1}')
echo "protobuf: $PROTOBUF_VERSION"
sed -i "s/protobuf:.*/protobuf: $PROTOBUF_VERSION/" ../pubspec.yaml

cd ~/inf_common/
git pull
git add *
git commit -m "Update protobuf"

cd protobuf
protoc --dart_out=grpc:../lib/src/ *.proto
# protoc --csharp_out=./cs/ *.proto
cd ../lib/src/
sed -f ../../protobuf/enum_sed.txt -i enum_protobuf.pbenum.dart
sed -f ../../protobuf/enum_sed.txt -i *.pb.dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
git add *
cd ../../protobuf/
# cd ../config
# cp ../protobuf/dart/config_*.dart lib/protobuf/
# cp ../protobuf/dart/data_*.dart lib/protobuf/
# cp ../protobuf/dart/enum_*.dart lib/protobuf/
# git add *
# cd ../api
# cp ../protobuf/*.dart lib/
# git add *
cd ..
git commit -m "Compile protobuf"

git push
git status


# cd ~/infclient
# git pull --recurse-submodules
# git add *
# git commit -m "Update protobuf"
# 
# cp ~/infcommon/protobuf/dart/*.dart infapp/lib/protobuf/
# git add *
# git commit -m "Compile protobuf"
# 
# git push
# git status
# 
# 
# cd ~/infserver
# git pull --recurse-submodules
# git add *
# git commit -m "Update protobuf"
# 
# cp ~/infcommon/protobuf/dart/*.dart api/lib/protobuf/
# git add *
# git commit -m "Compile protobuf"
# 
# git push
# git status


cd ~/inf_common/scripts
