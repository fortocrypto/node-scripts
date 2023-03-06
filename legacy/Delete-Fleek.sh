#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {

rm -f $HOME/.sdd_Fleek_do_not_remove
sudo systemctl stop fleek
sudo rm -rf /etc/systemd/system/fleek.service
sudo rm -rf $HOME/ursa
}


if [ -f $HOME/.sdd_Fleek_do_not_remove ]; then
  delete
  
fi