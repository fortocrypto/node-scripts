#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git apt-transport-https ca-certificates software-properties-common iptables build-essential wget jq make gcc tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
cd $HOME
if [ -d "/usr/local/go" ]; then
echo "Go already installed"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
else
ver="1.20.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
go version
fi
cd $SDD_NM_HOME/.Cascadia
git clone https://github.com/cascadiafoundation/cascadia && cd cascadia
git checkout v0.1.1
make install
wget -O $HOME/.cascadiad/config/genesis.json "https://anode.team/Cascadia/test/genesis.json"
peers="893b6d4be8b527b0eb1ab4c1b2f0128945f5b241@185.213.27.91:36656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.cascadiad/config/config.toml
SNAP_RPC=185.213.27.91:36657
sleep 5
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sleep 3
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.cascadiad/config/config.toml
tee /etc/systemd/system/cascadiad.service > /dev/null <<EOF
[Unit]
Description=cascadiad
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cascadiad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable cascadiad
systemctl restart cascadiad
}

install
