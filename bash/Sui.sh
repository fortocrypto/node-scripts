#!/bin/bash

function logo() {
  bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y


curl -s https://raw.githubusercontent.com/sorkand1/tools/main/install_docker.sh | bash
mkdir -p $HOME/sui
cd $HOME/sui
wget -O $HOME/sui/fullnode-template.yaml https://github.com/MystenLabs/sui/raw/main/crates/sui-config/data/fullnode-template.yaml
wget -O $HOME/sui/genesis.blob  https://github.com/MystenLabs/sui-genesis/raw/main/testnet/genesis.blob
IMAGE="mysten/sui-node:2698314d139a3018c2333ddaa670a7cb70beceee"
wget -O $HOME/sui/docker-compose.yaml https://raw.githubusercontent.com/MystenLabs/sui/main/docker/fullnode/docker-compose.yaml
sed -i.bak "s|image:.*|image: $IMAGE|" $HOME/sui/docker-compose.yaml
docker-compose up -d

}

function update() {

}

logo
if [ -f sdd_co_donotdelete_Sui ]; then
  update
else
  install
  touch sdd_co_donotdelete_Sui
fi
logo
