#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Nibiru_do_not_remove
cd $HOME
sudo systemctl stop nibid
sudo systemctl disable nibid
rm -rf $HOME/nibiru
rm -rf $HOME/.nibid
rm /usr/local/bin/nibid
rm /etc/systemd/system/nibid.service
}

logo
if [ -f $HOME/.sdd_Nibiru_do_not_remove ]; then
  delete
  logo
fi
