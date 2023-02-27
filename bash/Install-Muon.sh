#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git apt-transport-https ca-certificates software-properties-common -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
git clone https://github.com/muon-protocol/muon-node-js.git $SDD_NM_HOME/muon-node-js --recurse-submodules --branch testnet
cd $SDD_NM_HOME/muon-node-js
docker-compose build
docker-compose up -d
echo "alias muon_backup='docker exec -it muon-node ./node_modules/.bin/ts-node ./src/cmd keys backup > $HOME/backup.json && cat $HOME/backup.json'" >> ~/.profile
echo "alias muon_restore='docker exec -it muon-node ./node_modules/.bin/ts-node ./src/cmd keys restore'" >> ~/.profile
echo "alias muon_restart='docker restart muon-node'" >> ~/.profile
source ~/.profile
muon_backup
cd $HOME
}

install
