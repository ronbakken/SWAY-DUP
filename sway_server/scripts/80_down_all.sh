#!/bin/sh
set -x
cd "$DIR"

cd ../docker_inf_db
docker-compose down

cd ../docker_inf_local
docker-compose down

cd ../scripts_linux
