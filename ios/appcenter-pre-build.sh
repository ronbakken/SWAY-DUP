#!/usr/bin/env bash
set -e
set -x

cd ..
export PATH=`pwd`/flutter/bin:$PATH
export FLUTTER_ROOT=`pwd`/flutter

flutter doctor

pod repo update
flutter build ios --release --no-codesign
