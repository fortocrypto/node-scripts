#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Shardeum_do_not_remove
cd $HOME/.shardeum
docker-compose down -v
cd $HOME
rm -rf .shardeum
rm -rf installer.sh
}

logo
if [ -f $HOME/.sdd_Shardeum_do_not_remove ]; then
  delete
  logo
fi
