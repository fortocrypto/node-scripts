#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang pkg-config git-core libssl-dev build-essential libclang-12-dev git jq ncdu bsdmainutils htop -y
echo 'export VALIDATOR_ALIAS='$validator_alias >> $HOME/.bash_profile
source $HOME/.bash_profile
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
sleep 1
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
sleep 1
if ss -tulpen | awk '{print $5}' | grep -q ":26656$" ; then
echo -e "\e[31mInstallation is not possible, port 26656 already in use.\e[39m"
exit
else
echo ""
fi
cd $SDD_NM_HOME/.Namada
git clone https://github.com/anoma/namada
cd namada
git checkout v0.14.3
make build-release
sudo mv target/release/namada /usr/local/bin/
sudo mv target/release/namada[c,n,w] /usr/local/bin/
sleep 2
cd $SDD_NM_HOME/.Namada
git clone https://github.com/heliaxdev/tendermint
cd tendermint
git checkout v0.1.4-abciplus
make build
sudo mv build/tendermint /usr/local/bin/
cd $HOME
namada client utils join-network --chain-id public-testnet-6.0.a0266444b06
sleep 3
echo "[Unit]
Description=Namada Node
After=network.target
[Service]
User=$USER
WorkingDirectory=$HOME/.namada
Type=simple
ExecStart=/usr/local/bin/namada --base-dir=$HOME/.namada node ledger run
Environment=NAMADA_TM_STDOUT=true
RemainAfterExit=no
Restart=always
RestartSec=5s
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/namadad.service
sudo mv $HOME/namadad.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad
}

install
