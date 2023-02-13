#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Muon_do_not_remove
cd $HOME/muon-node-js
docker-compose down
cd $HOME
rm -rf muon-node-js
}

logo
if [ -f $HOME/.sdd_Muon_do_not_remove ]; then
  delete
  logo
fi
