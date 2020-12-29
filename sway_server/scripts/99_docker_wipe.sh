#!/bin/sh
set -x
cd "$DIR"

./98_docker_clean.sh
docker volume rm $(docker volume ls --filter dangling=true -q)
