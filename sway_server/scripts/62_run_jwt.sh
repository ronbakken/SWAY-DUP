#!/bin/sh
set -x
cd "$DIR"

cd ../inf_server_jwt
npm install
node server.js

cd ../scripts_linux
