#!/bin/bash

function update() {
sudo apt update && sudo apt upgrade -y
sudo systemctl stop gear-node
rm -rf /tmp/substrate-wasmer-cache/
cd $SDD_NM_HOME/.Gear
wget --no-check-certificate https://get.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
sudo chmod +x gear && sudo mv gear /usr/bin
sudo systemctl start gear-node
}

update
