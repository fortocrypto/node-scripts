#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git tmux build-essential pip -y
echo 'export ALCHEMY='$alchemy_address >> $HOME/.bash_profile
source $HOME/.bash_profile
sudo apt update && sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.10 python3.10-venv python3.10-dev libgmp-dev pkg-config libssl-dev -y
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
rustup update stable --force
cd $SDD_NM_HOME/.Starknet
git clone https://github.com/eqlabs/pathfinder.git
cd pathfinder
git fetch
git checkout v0.5.1
cd py
python3.10 -m venv .venv
source .venv/bin/activate
PIP_REQUIRE_VIRTUALENV=true pip install --upgrade pip
PIP_REQUIRE_VIRTUALENV=true pip install -e .[dev]
pytest
cd $SDD_NM_HOME/.Starknet/pathfinder/
cargo +stable build --release --bin pathfinder
sleep 2
source $HOME/.bash_profile
mv $SDD_NM_HOME/.Starknet/pathfinder/target/release/pathfinder /usr/local/bin/ || exit
echo "[Unit]
Description=StarkNet
After=network.target
[Service]
User=$USER
Type=simple
WorkingDirectory=$SDD_NM_HOME/.Starknet/pathfinder/py
ExecStart=/bin/bash -c \"source $SDD_NM_HOME/.Starknet/pathfinder/py/.venv/bin/activate && /usr/local/bin/pathfinder --http-rpc=\"0.0.0.0:9545\" --ethereum.url $ALCHEMY\"
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/starknetd.service
mv $HOME/starknetd.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable starknetd
sudo systemctl restart starknetd
}

install
