#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

cd $HOME
wget https://lamina1.github.io/lamina1/lamina1.latest.ubuntu-latest.tar.gz
tar -xvzf lamina1.latest.ubuntu-latest.tar.gz
cd $HOME/lamina1
curl https://lamina1.github.io/lamina1/config.testnet.tar | tar xf -
ip = hostname -I
sed -i "s/^public-ip *=.*/public-ip = \"$ip\"/;" $HOME/lamina1/configs/testnet/default.json
tee /etc/systemd/system/lamina1.service > /dev/null <<EOF
[Unit]
Description=lamina1
After=network-online.target
[Service]
User=root
WorkingDirectory=/root/lamina1
ExecStart=/root/lamina1/lamina1-node  --config-file /root/lamina1/configs/testnet/default.json
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable lamina1
systemctl restart lamina1

}

logo
install
touch $HOME/.sdd_Lamina_do_not_remove
logo
