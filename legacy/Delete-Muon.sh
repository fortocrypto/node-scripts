#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {

rm -f $HOME/.sdd_Muon_do_not_remove
cd $HOME/muon-node-js
muon_backup
docker-compose down
cd $HOME && rm -Rf cd $HOME/muon-node-js
}


if [ -f $HOME/.sdd_Muon_do_not_remove ]; then
  delete
  
fi
