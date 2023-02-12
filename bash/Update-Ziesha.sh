#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {
cd $HOME
sudo systemctl stop ziesha
cd $HOME/bazuka
git pull origin master
cargo update
cargo install --path .
# rm -rf /root/.bazuka #удаляйте базу данных только если нужно!
sudo systemctl restart ziesha
sudo journalctl -f -u ziesha
}

logo
if [ -f $HOME/.sdd_Ziesha_do_not_remove ]; then
  update
  logo
fi
