#!/bin/bash
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

protoc --dart_out=grpc:../lib/src/protos/ *.proto

# Set the pubspec.yaml to use the protobuf version used for compiling
PROTOBUF_VERSION=$(cat ~/.pub-cache/global_packages/protoc_plugin/pubspec.lock | \
    awk '/protobuf:/{p=1;next}{if(p){print}}' | \
    awk '/version:/{print $2}' | \
    awk 'NR==1{print $1}')
echo "protobuf: $PROTOBUF_VERSION"
sed -i "s/protobuf:.*/protobuf: $PROTOBUF_VERSION/" ../pubspec.yaml
