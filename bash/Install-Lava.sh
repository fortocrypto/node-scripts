#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang git pkg-config libssl-dev build-essential gcc chrony curl jq ncdu bsdmainutils htop net-tools lsof fail2ban wget -y
cd $HOME
if [ -d "/usr/local/go" ]; then
echo "Go already installed"
else
ver="1.19.4"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
go version
fi
cd $SDD_NM_HOME/.Lava
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.3.0/lavad
chmod +x lavad
mv lavad /usr/local/bin/
LAVA_CHAIN="lava-testnet-1"
LAVA_MONIKER="$monikername"
LAVA_WALLET="$walletname"
echo 'export LAVA_CHAIN='${LAVA_CHAIN} >> $HOME/.bash_profile
echo 'export LAVA_MONIKER='${LAVA_MONIKER} >> $HOME/.bash_profile
echo 'export LAVA_WALLET='${LAVA_WALLET} >> $HOME/.bash_profile
source $HOME/.bash_profile
lavad init $LAVA_MONIKER --chain-id=lava-testnet-1
lavad config chain-id $LAVA_CHAIN
cp $SDD_NM_HOME/GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json $HOME/.lava/config
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ulava\"/;" ~/.lava/config/app.toml
seeds="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.lava/config/config.toml
tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=lavad
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable lavad
systemctl restart lavad
}

install
