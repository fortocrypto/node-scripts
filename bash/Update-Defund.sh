#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {
cd $HOME
systemctl stop defund
cd $HOME/defund
git checkout v0.2.4
make install
systemctl restart defund
cd $HOME
}

logo
if [ -f $HOME/.sdd_Defund_do_not_remove ]; then
  update
  logo
fi
