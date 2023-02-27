#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install tar curl git ufw -y

cd
sudo ufw disable
sudo ufw allow 443
wget 'https://staticassets.meson.network/public/meson_cdn/v3.1.19/meson_cdn-linux-amd64.tar.gz' && tar -zxf meson_cdn-linux-amd64.tar.gz && rm -f meson_cdn-linux-amd64.tar.gz && cd ./meson_cdn-linux-amd64 && sudo ./service install meson_cdn

if [[ -z "$tokencommand" ]]; then
  read -p "Please insert set token and config command from website : : " _tokencommand
  export tokencommand=$_tokencommand
fi

echo $($tokencommand)
MESON=$HOME/meson_cdn-linux-amd64
echo 'export MESON=meson_cdn-linux-amd64' >>~/.bash_profile
source ~/.bash_profile
sudo $MESON/service start meson_cdn
sudo $MESON/service status meson_cdn

}

logo
install
touch $HOME/.sdd_Meson_do_not_remove
logo
