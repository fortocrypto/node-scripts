#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {
cd $HOME/muon-node-js
docker-compose down
docker-compose pull
docker-compose up -d
cd $HOME
}

logo
if [ -f $HOME/.sdd_Muon_do_not_remove ]; then
  update
  logo
fi
