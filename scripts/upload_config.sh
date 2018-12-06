#!/bin/sh
set -x

cd ~/inf_config
git pull

pub get
dart bin/upload_config.dart
