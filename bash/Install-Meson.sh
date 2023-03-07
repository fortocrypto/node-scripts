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
wget -P $SDD_NM_HOME/.Meson/ 'https://staticassets.meson.network/public/meson_cdn/v3.1.19/meson_cdn-linux-amd64.tar.gz' && tar -zxf meson_cdn-linux-amd64.tar.gz && rm -f meson_cdn-linux-amd64.tar.gz && cd $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64 && sudo $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64/service install meson_cdn
sudo $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64/meson_cdn config set --token=$token --https_port=443 --cache.size=30
cd
echo 'export MESON=$SDD_NM_HOME/.Meson/meson_cdn-linux-amd64' >>~/.bash_profile
source ~/.bash_profile
sudo $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64/service start meson_cdn
sudo $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64/service status meson_cdn
}

install
