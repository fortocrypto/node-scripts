#!/bin/bash

function delete() {
cat ~/.bazuka-wallet > ~/passPhraseBackup.txt
cd $HOME
sudo systemctl stop ziesha && sudo systemctl disable ziesha
rm -rf $SDD_NM_HOME/bazuka ~/.bazuka ~/.bazuka-wallet ~/.bazuka.yaml
rm /etc/systemd/system/ziesha.service
sudo systemctl daemon-reload
echo "yours passPhrase is saved in ~/passPhraseBackup.txt"
}

delete
