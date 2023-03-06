#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {

rm -f $HOME/.sdd_Kyve_do_not_remove
sudo systemctl stop kyved
sudo systemctl disable kyved
cd $HOME
rm /etc/systemd/system/kyved.service
rm /usr/local/bin/kyved
rm -r $HOME/kyve
rm -r $HOME/.kyve
}


if [ -f $HOME/.sdd_Kyve_do_not_remove ]; then
  delete
  
fi