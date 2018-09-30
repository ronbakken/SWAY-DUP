#!/bin/sh

cd ../protobuf

protoc --dart_out=./dart/ *.proto
protoc --csharp_out=./cs/ *.proto

cd dart
find . -name '*.dart' | xargs -n 1 dartfmt -w
cd ..

cd ../scripts
