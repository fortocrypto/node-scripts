#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang git pkg-config libssl-dev build-essential gcc chrony curl jq ncdu bsdmainutils htop net-tools lsof fail2ban wget -y

ver="1.19.4" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
wget https://files.kyve.network/chain/v1.0.0-rc0/kyved_linux_amd64.tar.gz && \
tar -xvzf kyved_linux_amd64.tar.gz  && \
mv kyved /usr/local/bin/ && \
rm kyved_linux_amd64.tar.gz
KYVE_CHAIN="kaon-1"

if [[ -z "$monikername" ]]; then
  read -p "Enter your moniker name: " _monikername
  export monikername=$_monikername
fi

KYVE_MONIKER="$monikername"

if [[ -z "$walletname" ]]; then
  read -p "Enter your wallet name: " _walletname
  export walletname=$_walletname
fi

KYVE_WALLET="$walletname"
echo 'export KYVE_CHAIN='${KYVE_CHAIN} >> $HOME/.bash_profile
echo 'export KYVE_MONIKER='${KYVE_MONIKER} >> $HOME/.bash_profile
echo 'export KYVE_WALLET='${KYVE_WALLET} >> $HOME/.bash_profile
source $HOME/.bash_profile
kyved init $KYVE_MONIKER --chain-id $KYVE_CHAIN
kyved  config chain-id $KYVE_CHAIN
curl https://raw.githubusercontent.com/KYVENetwork/networks/main/kaon-1/genesis.json > ~/.kyve/config/genesis.json
peers="7258cf2c1867cc5b997baa19ff4a3e13681f14f4@68.183.143.17:26656,e8c9a0f07bc34fb870daaaef0b3da54dbf9c5a3b@15.235.10.35:26656,801fa026c6d9227874eeaeba288eae3b800aad7f@52.29.15.250:26656,bc8b5fbb40a1b82dfba591035cb137278a21c57d@52.59.65.9:26656,430845649afaad0a817bdf36da63b6f93bbd8bd1@3.67.29.225:26656,b68e5131552e40b9ee70427879eb34e146ef20df@18.194.131.3:26656,78d76da232b5a9a5648baa20b7bd95d7c7b9d249@142.93.161.118:26656,97b5c38213e4a845c9a7449b11d811f149fa6710@65.109.85.170:56656,bbb7a427e04d38c74f574f6f0162e1359b66b330@93.115.25.18:39656,1dfe7262db2b9bf51c3b25030e01c89e62640bb1@65.109.71.35:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.kyve/config/config.toml
sudo tee /etc/systemd/system/kyved.service > /dev/null <<EOF
[Unit]
Description=kyve
After=network-online.target
[Service]
User=$USER
ExecStart=$(which kyved) start --home $HOME/.kyve
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable kyved
sudo systemctl restart kyved

}

logo
install
touch $HOME/.sdd_Kyve_do_not_remove
logo
