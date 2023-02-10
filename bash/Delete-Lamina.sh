#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Lamina_do_not_remove
cd $HOME
systemctl stop lamina1
systemctl disable lamina1
rm /etc/systemd/system/lamina1.service
systemctl daemon-reload
cd $HOME
rm -r $HOME/lamina1
rm -r $HOME/.lamina1
}

logo
if [ -f $HOME/.sdd_Lamina_do_not_remove ]; then
  delete
  logo
fi
