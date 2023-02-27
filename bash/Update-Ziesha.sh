#!/bin/bash

function update() {
cd $HOME
sudo systemctl stop ziesha
cd $SDD_NM_HOME/.Ziesha/bazuka
git pull origin master
cargo update
cargo install --path .
# rm -rf /root/.bazuka #удаляйте базу данных только если нужно!
sudo systemctl restart ziesha
sudo journalctl -f -u ziesha
}

update
