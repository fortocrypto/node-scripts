#!/bin/bash

function logo() {
  bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt update && sudo apt upgrade -y
sudo apt install mc git wget curl htop net-tools unzip jq build-essential ncdu tmux make cmake clang pkg-config libssl-dev protobuf-compiler -y


sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
sleep 1
source $HOME/.profile
cargo install sccache
cd $HOME
git clone https://github.com/fleek-network/ursa.git
cd ursa
make install
sudo tee <<EOF >/dev/null /etc/systemd/system/fleek.service
[Unit]
Description=Fleek node
[Service]
User=$USER
ExecStart=/root/.cargo/bin/ursa
WorkingDirectory=$HOME/ursa
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable fleek &>/dev/null
sudo systemctl restart fleek
echo "installation complete, check logs by command:"
echo "journalctl -n 100 -f -u fleek -o cat"

}

function update() {
sudo apt update && sudo apt upgrade -y
}

logo
if [ -f sdd_co_donotdelete_Fleek ]; then
  update
else
  install
  touch sdd_co_donotdelete_Fleek
fi
logo
