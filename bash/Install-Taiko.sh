#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git apt-transport-https ca-certificates software-properties-common -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
cd $SDD_NM_HOME/.Taiko
git clone https://github.com/taikoxyz/simple-taiko-node.git && cd simple-taiko-node
cp .env.sample .env
sleep 5
docker compose up -d
sleep 10
docker compose down
sed -i.bak -e "s/^L1_ENDPOINT_HTTP *=.*/L1_ENDPOINT_HTTP = $l1_endpoint_http/" .env
sed -i.bak -e "s/^L1_ENDPOINT_WS *=.*/L1_ENDPOINT_WS = $l1_endpoint_ws/" .env
sed -i.bak -e "s/^ENABLE_PROPOSER *=.*/ENABLE_PROPOSER = true/" .env
sed -i.bak -e "s/^L1_PROVER_PRIVATE_KEY *=.*/L1_PROVER_PRIVATE_KEY = $l1_prover_private_key/" .env
sleep 5
docker compose up -d
}

install
