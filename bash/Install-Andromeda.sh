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
else
ver="1.19.4"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
go version
fi
echo 'export VALIDATOR='\"$validator\" >> $HOME/.bash_profile
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
cd $SDD_NM_HOME/.Andromeda
git clone "https://github.com/andromedaprotocol/andromedad.git"
cd andromedad && git checkout galileo-3-v1.1.0-beta1
make build
sudo mv $SDD_NM_HOME/.Andromeda/andromedad/build/andromedad /usr/local/bin/ || exit
sleep 1
andromedad init "$VALIDATOR" --chain-id galileo-3
SEEDS="e711b6631c3e5bb2f6c389cbc5d422912b05316b@seed.ppnv.space:37256,5cfce64114f98e29878567bdd1adbebe18670fc6@andromeda-testnet-seed.itrocket.net:443"
PEERS="c043b90a737b92b26b39c52c502d7468dc6b1481@46.0.203.78:22258,9d058b4c4eb63122dfab2278d8be1bf6bf07f9ef@65.109.86.236:26656,7ac17e470c16814be55aa02a1611b23a3fba3097@75.119.141.16:26656,c5f6021d8da08ff53e90725c0c2a77f8d65f5e03@195.201.195.40:26656,bcdd1b337504f2d3523f6d63a7de1a2641187908@154.26.130.175:26656,1d94f397352dc20be4b56e4bfd9305649cbac778@65.108.232.150:20095,749114faeb62649d94b8ed496efbdcd4a08b2e3e@136.243.93.134:20095"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.andromedad/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uandr\"/" $HOME/.andromedad/config/app.toml
wget "https://raw.githubusercontent.com/andromedaprotocol/testnets/galileo-3/genesis.json" -O $HOME/.andromedad/config/genesis.json
andromedad tendermint unsafe-reset-all
wget "https://snapshot.yeksin.net/andromeda/addrbook.json" -O $HOME/.andromedad/config/addrbook.json
curl -L https://snapshot.yeksin.net/andromeda/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad
sleep 1
echo "[Unit]
Description=ANDROMEDA Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/andromedad start
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/andromedad.service
sudo mv $HOME/andromedad.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable andromedad
sudo systemctl restart andromedad
}

install
