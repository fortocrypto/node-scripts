#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils lsof git make ncdu htop screen unzip bc fail2ban tmux npm -y

cd $HOME
if ! command -v go &> /dev/null; then
ver="1.19.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
fi
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.16.3
make install

if [[ -z "$monikername" ]]; then
  read -p "Enter your nibiru node moniker name : " _monikername
  export monikername=$_monikername
fi

nibid init $monikername --chain-id nibiru-testnet-2
nibid config chain-id nibiru-testnet-2
curl https://anode.team/Nibiru/test/genesis.json > ~/.nibid/config/genesis.json
curl https://anode.team/Nibiru/test/addrbook.json > ~/.nibid/config/addrbook.json
peers="5d9432668a2acd0587ecb77b5728177d216c02bc@65.109.93.152:36317"
sed -i.bak -e "s/^seeds *=.*/seeds = "$seeds"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.nibid/config/config.toml
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=Nibiru
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
curl -s https://gist.githubusercontent.com/stakemepro/d5dbfb4df5ea1af388b99dd6b503b0a5/raw/8a8ecdbc1384cdac408f3960ed59be6987d8704c/prepare-nodejs.sh | bash
npm install shelljs --cli
curl -s https://gist.githubusercontent.com/stakemepro/de685868629b5f223d855be8c284513c/raw/bd7bdb34d21590c9cc01fffbc5e7d9fc17638973/set-ports-node.js | node '' nibid .nibid
SNAP_RPC=https://nibiru.rpc.t.anode.team:443
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.nibid/config/config.toml
curl -o - -L https://anode.team/Nibiru/test/anode.team_nibiru_wasm.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.nibid/data
sudo systemctl daemon-reload && sudo systemctl enable nibid
sudo systemctl restart nibid

}

logo
install
touch $HOME/.sdd_Nibiru_do_not_remove
logo
