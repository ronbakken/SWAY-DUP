#!/bin/bash
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd ../docker_sway_local
docker-compose down

cd ../docker_sway_db
docker-compose down

cd ../sway_server/scripts
