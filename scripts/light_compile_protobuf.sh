#!/bin/sh

cd ../protobuf

protoc --dart_out=../lib/src/ *.proto
# protoc --csharp_out=./cs/ *.proto

cd ../lib/src/
sed -f ../../protobuf/enum_sed.txt -i enum_protobuf.pbenum.dart
sed -f ../../protobuf/enum_sed.txt -i *.pb.dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
cd ../../protobuf/

cd ../scripts
