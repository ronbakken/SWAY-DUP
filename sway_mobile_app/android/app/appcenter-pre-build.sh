#!/usr/bin/env bash
set -e
set -x

cd ../..
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter

flutter doctor
flutter packages get
cat pubspec.lock

# Minimum supported Gradle version is 5.6.4. Current version is 5.6.2. 
# If using the gradle wrapper, try editing the distributionUrl in 
# /Users/runner/.pub-cache/hosted/pub.dartlang.org/device_info-1.0.0/android/gradle/wrapper/gradle-wrapper.properties 
# to gradle-5.6.4-all.zip
# echo $HOME
# sed -i '' 's/5\.6\.4/5\.6\.2/' $HOME/.pub-cache/hosted/pub.dartlang.org/device_info-1.0.0/android/gradle/wrapper/gradle-wrapper.properties

flutter build apk --release --build-name=1.0.$APPCENTER_BUILD_ID --build-number=$APPCENTER_BUILD_ID \
    || sed -i '' 's/5\.6\../5\.6\.4/' $HOME/.pub-cache/hosted/pub.dartlang.org/device_info-1.0.0/android/gradle/wrapper/gradle-wrapper.properties \
    && flutter build apk --release --build-name=1.0.$APPCENTER_BUILD_ID --build-number=$APPCENTER_BUILD_ID

cat $HOME/.pub-cache/hosted/pub.dartlang.org/device_info-1.0.0/android/gradle/wrapper/gradle-wrapper.properties

# You are building a fat APK that includes binaries for android-arm, android-arm64, android-x64.
# If you are deploying the app to the Play Store, it's recommended to use app bundles or split the APK to reduce the APK size.
#     To generate an app bundle, run:
#         flutter build appbundle --target-platform android-arm,android-arm64,android-x64
#         Learn more on: https://developer.android.com/guide/app-bundle
#     To split the APKs per ABI, run:
#         flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
#         Learn more on:  https://developer.android.com/studio/build/configure-apk-splits#configure-abi-split


# Copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_
