#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Ziesha_do_not_remove
cat ~/.bazuka-wallet > ~/passPhraseBackup.txt
cd $HOME
sudo systemctl stop ziesha && sudo systemctl disable ziesha
rm -rf ~/bazuka ~/.bazuka ~/.bazuka-wallet ~/.bazuka.yaml
rm /etc/systemd/system/ziesha.service
sudo systemctl daemon-reload
echo "yours passPhrase is saved in ~/passPhraseBackup.txt"
}

logo
if [ -f $HOME/.sdd_Ziesha_do_not_remove ]; then
  delete
  logo
fi
