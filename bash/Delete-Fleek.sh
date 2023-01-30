#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Fleek_do_not_remove
sudo systemctl stop fleek
sudo rm -rf /etc/systemd/system/fleek.service
sudo rm -rf $HOME/ursa
}

logo
if [ -f $HOME/.sdd_Fleek_do_not_remove ]; then
  delete
  logo
fi
