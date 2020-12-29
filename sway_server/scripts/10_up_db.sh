#!/bin/sh
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ../../docker_sway_db
docker-compose up -d

# To wipe all databases:
# docker compose down -v

cd ../scripts_linux
