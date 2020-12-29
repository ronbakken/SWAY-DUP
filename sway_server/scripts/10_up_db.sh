#!/bin/bash
set -x
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd ../docker_sway_db
docker-compose pull && docker-compose up -d
docker-compose logs

while ! nc -z localhost 3306; do timeout --preserve-status 1s docker-compose logs --follow mariadb_general; done
while ! nc -z localhost 3307; do timeout --preserve-status 1s docker-compose logs --follow mariadb_accounts; done
while ! nc -z localhost 3308; do timeout --preserve-status 1s docker-compose logs --follow mariadb_proposals; done

while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:5601/app/kibana)" != "200" ]]; do timeout --preserve-status 1s docker-compose logs --follow elasticsearch elasticsearch2 kibana; done

cd ../sway_server/scripts
