#!/bin/bash

function update() {
sudo apt update && sudo apt upgrade -y
sudo systemctl stop fleek
cd $SDD_NM_HOME/.Fleek/ursa
git pull
make install
source $HOME/.profile
sudo systemctl restart fleek
}

update
