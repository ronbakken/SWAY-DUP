#!/bin/sh

cd ../protobuf

protoc --dart_out=./dart/ *.proto
# protoc --csharp_out=./cs/ *.proto

cd dart
sed -f ../enum_sed.txt -i enum_protobuf.pbenum.dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
cd ..

cd ../scripts
