#!/bin/bash
set -x

# This script runs from sway_mobile_app
echo $PWD

cp -u ../sway_config/blob/config_alpha.bin assets/config.bin
cp -n android/key.properties.sway-dev android/key.properties
