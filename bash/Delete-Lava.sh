#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Lava_do_not_remove
cd $HOME
systemctl stop lavad
systemctl disable lavad
rm -f /etc/systemd/system/lavad.service
rm -rf GHFkqmTzpdNLDd6T
rm -rf .lava
rm -f /usr/local/bin/lavad
}

logo
if [ -f $HOME/.sdd_Lava_do_not_remove ]; then
  delete
  logo
fi
