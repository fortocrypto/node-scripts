#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_5ire_do_not_remove
docker rm $(docker stop $(docker ps -a -q --filter ancestor=5irechain/5ire-thunder-node:0.12 --format="{{.ID}}"))
docker image rm 5irechain/5ire-thunder-node:0.12
service docker restart
}

logo
if [ -f $HOME/.sdd_5ire_do_not_remove ]; then
  delete
  logo
fi
