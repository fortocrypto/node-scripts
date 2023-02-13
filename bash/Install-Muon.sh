#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common git -y

cd $HOME
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
git clone https://github.com/muon-protocol/muon-node-js.git --recurse-submodules --branch testnet
cd $HOME/muon-node-js
docker-compose build
docker-compose up -d

}

logo
install
touch $HOME/.sdd_Muon_do_not_remove
logo
