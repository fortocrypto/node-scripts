#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git apt-transport-https ca-certificates software-properties-common -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
cd $SDD_NM_HOME/.Muon/
curl -o docker-compose.yml https://raw.githubusercontent.com/muon-protocol/muon-node-js/testnet/docker-compose-pull.yml
docker-compose pull
docker-compose up -d
echo "alias muon_restore='docker exec -it muon-node ./node_modules/.bin/ts-node ./src/cmd keys restore'" >> ~/.profile
echo "alias muon_restart='docker restart muon-node'" >> ~/.profile
source ~/.profile
cd $HOME
}

install
