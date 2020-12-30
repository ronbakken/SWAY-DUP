#!/bin/sh
set -x
cd "$DIR"

cd ../docker_inf_local
docker-compose pull & docker-compose build && docker-compose up -d

cd ../scripts_linux
