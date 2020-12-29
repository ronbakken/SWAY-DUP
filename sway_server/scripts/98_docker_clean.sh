#!/bin/sh
set -x
cd "$DIR"

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker network prune -f
docker rmi $(docker images -f dangling=true -q)
