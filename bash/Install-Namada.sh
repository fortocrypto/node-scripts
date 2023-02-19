#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make git-core libssl-dev pkg-config libclang-12-dev build-essential curl wget -y

cd $HOME
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export NAMADA_TAG=v0.13.4
export TM_HASH=v0.1.4-abciplus
git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
make build-release
make install
git clone https://github.com/heliaxdev/tendermint && cd tendermint && git checkout $TM_HASH
make build
namada --version
export CHAIN_ID="public-testnet-3.0.81edd4d6eb6"
namada client utils join-network --chain-id $CHAIN_ID
sudo tee /etc/systemd/system/namada.service  > /dev/null <<EOF
[Unit]
Description=Namada Node
After=network.target
[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=$(which namada) node ledger run
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable namada
sudo systemctl start namada

}

logo
install
touch $HOME/.sdd_Namada_do_not_remove
logo
