#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {
cd $HOME
docker-compose down
docker-compose pull
docker-compose run --rm --entrypoint "./bin/run migrations:start" ironfish
docker-compose up -d
}

logo
if [ -f $HOME/.sdd_IronFish_do_not_remove ]; then
  update
  logo
fi
