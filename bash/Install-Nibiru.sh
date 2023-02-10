#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop curl wget -y

cd $HOME

if [[ -z "$monikername" ]]; then
  read -p "Enter your nibiru node moniker name : " _monikername
  export monikername=$_monikername
fi

echo 'export NIBIRU_NODENAME='\"$monikername\" >> $HOME/.bash_profile
NETWORK=nibiru-testnet-2
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile
wget -O go1.19.2.linux-amd64.tar.gz https://golang.org/dl/go1.19.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz && rm go1.19.2.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.16.3
make build
sudo mv ./build/nibid /usr/local/bin/ || exit
nibid init "$NIBIRU_NODENAME" --chain-id=nibiru-testnet-2
sed -i.default 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i "s/pruning *=.*/pruning = \"custom\"/g" $HOME/.nibid/config/app.toml
sed -i "s/pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/g" $HOME/.nibid/config/app.toml
sed -i "s/pruning-interval *=.*/pruning-interval = \"10\"/g" $HOME/.nibid/config/app.toml
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.testnet.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|enable =.*|enable = true|g' $HOME/.nibid/config/config.toml
sed -i 's|rpc_servers =.*|rpc_servers = "'$(curl -s https://networks.testnet.nibiru.fi/$NETWORK/rpc_servers)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_height =.*|trust_height = "'$(curl -s https://networks.testnet.nibiru.fi/$NETWORK/trust_height)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_hash =.*|trust_hash = "'$(curl -s https://networks.testnet.nibiru.fi/$NETWORK/trust_hash)'"|g' $HOME/.nibid/config/config.toml
wget -O $HOME/.nibid/config/genesis.json https://networks.testnet.nibiru.fi/nibiru-testnet-2/genesis
nibid tendermint unsafe-reset-all
echo "[Unit]
Description=Nibiru Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/nibid start
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/nibid.service
sudo mv $HOME/nibid.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid

}

logo
install
touch $HOME/.sdd_Nibiru_do_not_remove
logo
