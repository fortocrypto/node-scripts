#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {
reset
rm -f $HOME/.sdd_Gitopia_do_not_remove
cd $HOME
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $(which gitopiad) -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $HOME/gitopia -rf
sed -i '/GITOPIA_/d' ~/.bash_profile
sudo ufw reset
sudo ufw disable
}

logo
if [ -f $HOME/.sdd_Gitopia_do_not_remove ]; then
  delete
  logo
fi
