#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install htop mc curl tar wget git make ncdu jq chrony net-tools iotop nload -y
cd $SDD_NM_HOME/.Gear
wget --no-check-certificate https://get.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz
sudo chmod +x gear && sudo mv gear /usr/bin
export GEAR_NODE_NAME=$nodename
sudo tee /etc/systemd/system/gear-node.service > /dev/null <<EOF
[Unit]
Description=Gear-node
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/gear --name '$GEAR_NODE_NAME' --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable gear-node
sudo systemctl restart gear-node
}

install
