#!/usr/bin/env bash
set -e
set -x

cd ..
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter

flutter doctor
flutter packages get
cat pubspec.lock

pod repo update
flutter build ios --release --no-codesign --no-tree-shake-icons --build-name=1.0.$APPCENTER_BUILD_ID --build-number=$APPCENTER_BUILD_ID
