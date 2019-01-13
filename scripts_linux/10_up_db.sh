#!/bin/sh
set -x
cd "$DIR"

cd ../docker_inf_db
docker-compose up &

cd ../scripts
