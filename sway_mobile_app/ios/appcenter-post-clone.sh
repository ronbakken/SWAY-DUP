#!/usr/bin/env bash
set -e
set -x

echo `pwd`

# Use sandbox configuration
cp ../../sway_config/blob/config_alpha.bin ../../assets/config.bin
# cp ../android/key.properties.sway-dev ../../android/key.properties

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
