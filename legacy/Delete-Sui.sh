#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {

rm -f $HOME/.sdd_Sui_do_not_remove
cd $HOME/sui
docker-compose down -v
sudo rm -rf ~/sui /var/sui/ /usr/local/bin/sui*
}


if [ -f $HOME/.sdd_Sui_do_not_remove ]; then
  delete
  
fi
