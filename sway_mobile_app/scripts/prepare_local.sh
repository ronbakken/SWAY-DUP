#!/bin/bash
set -x

# This script runs from sway_mobile_app
echo $PWD

cp ../sway_config/blob/config_local.bin assets/config.bin
cp -n android/key.properties.sway-dev android/key.properties

echo "Switch to the Debug Console to continue"
