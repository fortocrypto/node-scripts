#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
cd $HOME
if [ -d "/usr/local/go" ]; then
echo "Go already installed"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
else
ver="1.19.4"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
go version
fi
cd $SDD_NM_HOME/.Goracle
wget https://staging.dev.goracle.io/downloads/latest-staging/goracle
sudo mv goracle /usr/bin
sudo chmod u+x /usr/bin/goracle
}

install
