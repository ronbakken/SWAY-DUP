#!/bin/sh
set -x
cd "$DIR"
exit # disabled
git pull

# pub global activate protoc_plugin

# Set the pubspec.yaml to use the protobuf version used for compiling
PROTOBUF_VERSION=$(cat ~/.pub-cache/global_packages/protoc_plugin/pubspec.lock | \
    awk '/protobuf:/{p=1;next}{if(p){print}}' | \
    awk '/version:/{print $2}' | \
    awk 'NR==1{print $1}')
echo "protobuf: $PROTOBUF_VERSION"
sed -i "s/protobuf:.*/protobuf: $PROTOBUF_VERSION/" ../pubspec.yaml

cd ..
git add *
git commit -m "Update protobuf"

cd protobuf
protoc --dart_out=grpc:../lib/src/ *.proto
# protoc --csharp_out=./cs/ *.proto
cd ../lib/src/
# Replace enum values with dart-friendly enum values
sed -f ../../protobuf/enum_sed.txt -i enum_protobuf.pbenum.dart
sed -f ../../protobuf/enum_sed.txt -i *.pb.dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
git add *
cd ../..
git commit -m "Compile protobuf"

git push
git status

cd scripts
