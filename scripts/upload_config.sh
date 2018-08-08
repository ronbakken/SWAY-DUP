#!/bin/sh
set -x

cd ~/infcommon
git pull --recurse-submodules

cd config
pub get
pub upgrade
dart bin/upload.dart
