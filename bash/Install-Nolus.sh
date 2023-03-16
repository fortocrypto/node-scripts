#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl build-essential git wget jq make gcc tmux chrony clang pkg-config libssl-dev ncdu bsdmainutils htop -y
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
echo 'export NOLUS_NODENAME='\"$nolusnodename\" >> $HOME/.bash_profile
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile
sleep 1
cd $SDD_NM_HOME/.Nolus
git clone https://github.com/Nolus-Protocol/nolus-core
cd nolus-core
git checkout v0.1.39
make build
sudo mv $SDD_NM_HOME/.Nolus/target/release/nolusd /usr/local/bin/ || exit
nolusd init "$NOLUS_NODENAME" --chain-id=nolus-rila
#seeds="8e1590558d8fede2f8c9405b7ef550ff455ce842@51.79.30.9:26656,bfffaf3b2c38292bd0aa2a3efe59f210f49b5793@51.91.208.71:26656,106c6974096ca8224f20a85396155979dbd2fb09@198.244.141.176:26656"
peers="56cee116ac477689df3b4d86cea5e49cfb450dda@54.246.232.38:26656,56f14005119e17ffb4ef3091886e6f7efd375bfd@34.241.107.0:26656,7f26067679b4323496319fda007a279b52387d77@63.35.222.83:26656,7f4a1876560d807bb049b2e0d0aa4c60cc83aa0a@63.32.88.49:26656,3889ba7efc588b6ec6bdef55a7295f3dd559ebd7@3.249.209.26:26656,de7b54f988a5d086656dcb588f079eb7367f6033@34.244.137.169:26656"
#sed -i "s/^seeds *=.*/seeds = \"$seeds\"/;" $HOME/.nolus/config/config.toml
sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/;" $HOME/.nolus/config/config.toml
sed -i.default 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0025unls"/g' $HOME/.nolus/config/app.toml
sed -i "s/pruning *=.*/pruning = \"custom\"/g" $HOME/.nolus/config/app.toml
sed -i "s/pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/g" $HOME/.nolus/config/app.toml
sed -i "s/pruning-interval *=.*/pruning-interval = \"10\"/g" $HOME/.nolus/config/app.toml
wget -O $HOME/.nolus/config/genesis.json https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/genesis.json
nolusd tendermint unsafe-reset-all --home $HOME/.nolus
echo "[Unit]
Description=Nolus Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/nolusd start
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/nolusd.service
sudo mv $HOME/nolusd.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sleep 4
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable nolusd
sudo systemctl restart nolusd
}

install
