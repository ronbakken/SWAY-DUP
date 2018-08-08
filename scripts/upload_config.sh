#!/bin/sh
set -x

cd ~/infcommon
git pull --recurse-submodules

cd config
pub get
dart bin/upload.dart
