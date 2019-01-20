#!/usr/bin/env bash
set -e
set -x

echo `pwd`
mkdir ~/.ssh
cp ../../ssh/* ~/.ssh/
chmod 600 ~/.ssh/*
ls -al ~/.ssh/

# Use sandbox configuration
rm ../../assets/config.bin
cp ../../assets/config_ats3.bin ../../assets/config.bin
cp ../../android/key.properties.infsandbox ../../android/key.properties

cd ../..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter
echo $PATH

flutter doctor
