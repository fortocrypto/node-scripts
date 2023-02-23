#!/bin/bash

function update() {
cd $SDD_NM_HOME/.IronFish
docker-compose down
docker-compose pull
docker-compose run --rm --entrypoint "./bin/run migrations:start" ironfish
docker-compose up -d
}

update
