#!/bin/bash

function update() {
sudo apt update && sudo apt upgrade -y
cd $SDD_NM_HOME/.Gaga
curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz && tar -zxf apphub-linux-amd64.tar.gz && rm -f apphub-linux-amd64.tar.gz && cd ./apphub-linux-amd64 && sudo ./apphub service install
sudo ./apphub service start
./apphub status
sudo ./apps/gaganode/gaganode config set --token=umliefloqejwwgzgfc18e616614e36a4
./apphub restart
}

update
