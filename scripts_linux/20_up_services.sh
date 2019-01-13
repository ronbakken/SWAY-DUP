#!/bin/sh
set -x
cd "$DIR"

cd ../docker_inf_local
docker-compose build && docker-compose up &

cd ../scripts
