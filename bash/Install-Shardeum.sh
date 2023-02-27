#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git npm -y
apt remove npm -y
rm -Rf $HOME/.npm
apt install npm -y
npm cache clean -f
npm install -g n
n stable
npm install -g npm@latest
sudo apt install docker.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd $SDD_NM_HOME
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh && chmod +x installer.sh && ./installer.sh
cd $SDD_NM_HOME/.shardeum
. ./shell.sh
operator-cli gui start
}

install
