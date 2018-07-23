#!/bin/sh

cd ../protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
cd ../scripts
