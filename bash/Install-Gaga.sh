#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install tar curl git ufw ca-certificates -y
cd $SDD_NM_HOME/.Gaga
curl -o app-linux-amd64.tar.gz  https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz && tar -zxf app-linux-amd64.tar.gz && rm -f app-linux-amd64.tar.gz && cd ./app-linux-amd64 && sudo ./app service install
sleep 3
sudo ./app service start
sleep 30
sudo ./apps/gaganode/gaganode config set --token="$yourtoken"
sudo ./app restart
}

install
