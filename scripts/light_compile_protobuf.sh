#!/bin/sh

cd ../protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
find . -name '*.dart' | xargs -n 1 dartfmt -w
cd ../scripts
