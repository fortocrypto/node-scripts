#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git -y

curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
docker pull 5irechain/5ire-thunder-node:0.12
sudo docker run -d "-p 30333:30333  -p 9933:9933 -p 9944:9944 5irechain/5ire-thunder-node:0.12  --port 30333 --no-telemetry --name 5ire-thunder-archive --base-path /5ire/data --keystore-path /5ire/data   --node-key-file /5ire/secrets/node.key --chain /5ire/thunder-chain-spec.json --bootnodes /ip4/3.128.99.18/tcp/30333/p2p/12D3KooWSTawLxMkCoRMyzALFegVwp7YsNVJqh8D2p7pVJDqQLhm --pruning archive --ws-external --rpc-external --rpc-cors all"
docker run -d "-p 30333:30333 5irechain/5ire-thunder-node:0.12 --port 30333 --no-telemetry --name 5ire-thunder-validator --base-path /5ire/data --keystore-path /5ire/data --node-key-file /5ire/secrets/node.key --chain /5ire/thunder-chain-spec.json --bootnodes /ip4/3.128.99.18/tcp/30333/p2p/12D3KooWSTawLxMkCoRMyzALFegVwp7YsNVJqh8D2p7pVJDqQLhm --validator"

}

logo
install
touch $HOME/.sdd_5ire_do_not_remove
logo
