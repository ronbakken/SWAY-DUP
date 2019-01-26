#!/usr/bin/env bash
set -e
set -x

cd ../..
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter

flutter doctor
flutter packages get
cat pubspec.lock

flutter build apk --release --build-name=1.0.$APPCENTER_BUILD_ID --build-number=$APPCENTER_BUILD_ID

# Copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_
