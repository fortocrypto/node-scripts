#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh
cd $SDD_NM_HOME/.Goerli
git clone https://github.com/base-org/node.git
cd node
sed -i -e "s|^OP_NODE_L1_ETH_RPC *=.*|OP_NODE_L1_ETH_RPC =$l1rpcurl|" $SDD_NM_HOME/.Goerli/node/docker-compose.yml
docker compose up
}

install
