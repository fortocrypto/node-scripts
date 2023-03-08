#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install tar curl git ufw -y
cd
sudo ufw disable
sudo ufw allow 443
cd $SDD_NM_HOME/.Meson
wget 'https://staticassets.meson.network/public/meson_cdn/v3.1.19/meson_cdn-linux-amd64.tar.gz' && tar -zxf meson_cdn-linux-amd64.tar.gz && rm -f meson_cdn-linux-amd64.tar.gz && cd ./meson_cdn-linux-amd64 && sudo ./service install meson_cdn
sudo ./meson_cdn config set --token=$token --https_port=443 --cache.size=30
echo 'export MESON=$SDD_NM_HOME/.Meson/meson_cdn-linux-amd64' >>~/.bash_profile
source ~/.bash_profile
sudo ./service start meson_cdn
sudo ./service status meson_cdn
}

install
