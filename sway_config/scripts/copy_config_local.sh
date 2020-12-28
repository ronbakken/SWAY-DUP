#!/bin/bash
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ../..
cp sway_config/blob/config_local.bin sway_mobile_app/assets/config.bin
