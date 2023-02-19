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

sudo apt update
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
. $HOME/.cargo/env
curl https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt install cargo nodejs -y < "/dev/null"
cargo --version
source ~/.cargo/env
ver="1.19.4"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

if [[ -z "$monikername" ]]; then
  read -p "Enter your moniker name: : " _monikername
  export monikername=$_monikername
fi

echo "export VALIDATOR_ALIAS=$monikername" >> ~/.bash_profile
cd $HOME && git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
make build-release
cd $HOME && git clone https://github.com/heliaxdev/tendermint && cd tendermint && git checkout $TM_HASH
make build
cd $HOME && cp $HOME/tendermint/build/tendermint  /usr/local/bin/tendermint && cp "$HOME/namada/target/release/namada" /usr/local/bin/namada && cp "$HOME/namada/target/release/namadac" /usr/local/bin/namadac && cp "$HOME/namada/target/release/namadan" /usr/local/bin/namadan && cp "$HOME/namada/target/release/namadaw" /usr/local/bin/namadaw
tendermint version
namada --version
cd $HOME && wget "https://github.com/heliaxdev/anoma-network-config/releases/download/public-testnet-3.0.81edd4d6eb6/public-testnet-3.0.81edd4d6eb6.tar.gz"
tar xvzf "$HOME/public-testnet-3.0.81edd4d6eb6.tar.gz"
sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.namada
Environment=NAMADA_LOG=debug
Environment=NAMADA_TM_STDOUT=true
ExecStart=/usr/local/bin/namada --base-dir=$HOME/.namada node ledger run
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl start namadad

}

logo
install
touch $HOME/.sdd_Namada_do_not_remove
logo
