#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install wget jq git curl build-essential libssl-dev gcc cmake mc -y

curl https://sh.rustup.rs -sSf | sh -s -- -y
source ~/.cargo/env
cd $HOME
git clone https://github.com/ziesha-network/bazuka
cd $HOME/bazuka
git pull origin master
cargo install --path .
bazuka init --network pelmeni-5 --bootstrap 65.108.193.133:8765

if [[ -z "$discordname" ]]; then
  read -p "Your discord name: " _discordname
  export discordname=$_discordname
fi

ZEEKADISCORD=$discordname
echo "export ZEEKADISCORD="${ZEEKADISCORD}"" >> $HOME/.bash_profile
source $HOME/.bash_profile
sudo tee <<EOF >/dev/null /etc/systemd/system/ziesha.service
[Unit]
Description=Zeeka node
After=network.target
[Service]
User=$USER
ExecStart=`RUST_LOG=info which bazuka` node start --discord-handle "$ZEEKADISCORD"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
passPhrase=$(cat ~/.bazuka-wallet)
echo "yours passPhrase is: $passPhrase and TOU MUST SAVE IT IN SAFE PLACE"
echo "to check node status use command: bazuka node status"
echo "to check node logs: sudo journalctl -f -u ziesha"
sudo systemctl daemon-reload
sudo systemctl enable ziesha
sudo systemctl restart ziesha

}

logo
install
touch $HOME/.sdd_Ziesha_do_not_remove
logo
