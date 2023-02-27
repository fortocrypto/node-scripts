#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Sui_do_not_remove
cd $HOME/sui
docker-compose down -v
sudo rm -rf ~/sui /var/sui/ /usr/local/bin/sui*
sudo rm /etc/systemd/system/suid.service
}

logo
if [ -f $HOME/.sdd_Sui_do_not_remove ]; then
  delete
  logo
fi
