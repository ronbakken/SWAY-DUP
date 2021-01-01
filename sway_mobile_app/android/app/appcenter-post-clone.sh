#!/usr/bin/env bash
set -e
set -x

echo `pwd`

# Use sandbox configuration
cp ../../../blob/config_alpha.bin ../../assets/config.bin
cp ../../android/key.properties.sway-dev ../../android/key.properties

cd ../..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter
echo $PATH

flutter doctor
