#!/bin/bash

function update() {
sudo apt update && sudo apt upgrade -y
sudo systemctl stop subspaced
cd $SDD_NM_HOME/.Subspace
wget -O subspace-cli https://github.com/subspace/subspace-cli/releases/download/v0.1.10-alpha/subspace-cli-Ubuntu-x86_64-v3-v0.1.10-alpha
sudo chmod +x subspace-cli
sudo rm /usr/local/bin/subspace-cli
sudo mv subspace-cli /usr/local/bin/
source $HOME/.bash_profile
sudo systemctl restart subspaced
}

update
