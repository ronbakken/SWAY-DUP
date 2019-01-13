#!/bin/sh
set -x
cd "$DIR"

cd ../inf_server_push
pub get
dart bin/main.dart ../assets/config_local_server.bin

cd ../scripts
