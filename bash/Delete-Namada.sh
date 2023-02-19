#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Namada_do_not_remove
cd $HOME
sudo systemctl stop namada
sudo systemctl disable namada
sudo rm -rf /etc/systemd/system/namada.service
sudo systemctl daemon-reload
sudo rm -rf /usr/local/bin/namada
sudo rm -rf $HOME/namada
sudo rm -rf $HOME/tendermint
}

logo
if [ -f $HOME/.sdd_Namada_do_not_remove ]; then
  delete
  logo
fi
