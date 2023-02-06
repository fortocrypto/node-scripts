#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Defund_do_not_remove
cd $HOME
sudo systemctl stop defund
sudo systemctl disable defund
sudo rm -rf /etc/systemd/system/defund.service
sudo systemctl daemon-reload
rm -rf $HOME/defund
rm -rf $HOME/.defund
rm -rf $HOME/go
unset DEFUND_CHAIN
unset DEFUND_MONIKER
unset DEFUND_WALLET
unset monikername
unset walletname
}

logo
if [ -f $HOME/.sdd_Defund_do_not_remove ]; then
  delete
  logo
fi
