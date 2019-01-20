#!/usr/bin/env bash
set -e
set -x

echo `pwd`
ls -al
ls -al ~/.ssh/
cat ~/.ssh/config
cp ./ssh/* ~/.ssh/
ls -al ~/.ssh/
cat ~/.ssh/config
chmod 600 ~/.ssh/*
ls -al ~/.ssh/
rm assets/config.bin

# Use sandbox configuration
cp assets/config_ats3.bin assets/config.bin
# cp android/key.properties.infsandbox android/key.properties

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter
echo $PATH

flutter doctor

# brew update
# brew install --HEAD usbmuxd
# brew link usbmuxd
# brew install --HEAD libimobiledevice
# brew install ideviceinstaller ios-deploy cocoapods
# pod setup

pod repo update

flutter build ios --release --no-codesign
