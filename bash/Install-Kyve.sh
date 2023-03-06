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
cd $SDD_NM_HOME/.Kyve
wget https://files.kyve.network/chain/v1.0.0-rc0/kyved_linux_amd64.tar.gz && \
tar -xvzf kyved_linux_amd64.tar.gz  && \
mv kyved /usr/local/bin/ && \
rm kyved_linux_amd64.tar.gz
KYVE_CHAIN="kaon-1"
KYVE_MONIKER="$monikername"
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
sleep 1
available_ports=$(ss -Htan | awk '{print $4}' | cut -d ':' -f 2 | grep -v -E '^(0|1|5|6|7|8|9)' | sort -un)
selected_ports=$(echo "$available_ports" | shuf -n 8)
i=1
for port in $selected_ports; do
varname="var$i"
eval $varname=$port
((i++))
done
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:$var1\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:$var2\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:$var3\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:$var4\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":$var5\"%" $HOME/.kyve/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:$var6\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:$var7\"%" $HOME/.kyve/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:$var2\"%" $HOME/.kyve/config/client.toml
sudo systemctl restart kyved
}

install
