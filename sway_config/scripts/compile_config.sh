#!/bin/bash
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ..
dart bin/compile_config.dart
