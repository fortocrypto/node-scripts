#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_IronFish_do_not_remove
docker-compose down
rm -Rf $HOME/.ironfish
rm $HOME/docker-compose.yaml
}

logo
if [ -f $HOME/.sdd_IronFish_do_not_remove ]; then
  delete
  logo
fi
