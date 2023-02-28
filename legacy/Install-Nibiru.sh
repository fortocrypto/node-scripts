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
sudo mv ./build/nibid /usr/local/bin/

if [[ -z "$monikername" ]]; then
  read -p "Enter your nibiru node moniker name : " _monikername
  export monikername=$_monikername
fi

NIBIRU_MONIKER="$monikername"
NIBIRU_CHAIN="nibiru-testnet-2"
echo 'export NIBIRU_MONIKER='${NIBIRU_MONIKER} >> $HOME/.bash_profile
echo 'export NIBIRU_CHAIN='${NIBIRU_CHAIN} >> $HOME/.bash_profile
source $HOME/.bash_profile
nibid init "$NIBIRU_MONIKER" --chain-id=nibiru-testnet-2
#seeds="8e1590558d8fede2f8c9405b7ef550ff455ce842@51.79.30.9:26656,bfffaf3b2c38292bd0aa2a3efe59f210f49b5793@51.91.208.71:26656,106c6974096ca8224f20a85396155979dbd2fb09@198.244.141.176:26656"
#peers="5c30c7e8240f2c4108822020ae95d7b5da727e54@65.108.75.107:19656,dd8b9d6b2351e9527d4cac4937a8cb8d6013bb24@185.165.240.179:26656,55b33680faaad0889dddcd940c4e7f77cc74186a@194.163.151.154:26656,31b592b7b8e37af2a077c630a96851fe73b7386f@138.201.251.62:26656,97e599a3709d73936217e469bcea4cd1e5d837a0@178.62.24.214:39656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656,7ddc65049ebdab36cef6ceb96af4f57af5804a88@77.37.176.99:16656,ca251c4c914c0c70a32a2fdc00a6ea519a0a8856@45.141.122.178:26656,dd2a68405c170f14211a0c50ab6e0c1d48b4faf3@207.180.242.141:26656,2fc98a228dee1826d67e8a2dbd553989118a49cc@5.9.22.14:60656,2cd56c7b5d19b60246960a92b928a99d5c272210@154.26.138.94:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,ab5255a0607b7bdde58b4c7cd090c25255503bc6@199.175.98.111:36656,6369e3aefce2560b2073913d9317b3e9a0b06ab5@65.108.9.25:39656,16a5f0db538cafa0399c5a2b32b1d014b17932d4@162.55.27.100:39656,dc9554474fab76a9d62d4ab5d833f9fa7487a4eb@20.115.40.141:39656,35d8f676cf4db0f4ed7f3a8750daf8010797bdc4@135.181.116.109:20086,4be11bdbbab4541f7b663bcae8367928d48d3c4c@131.153.203.247:39656,ac8e43ccbdf25be95d7b85178c66f45453df0c7d@94.103.91.28:39656,1b49b68b6547b209c2c2ac8a5901a0d6c26edf03@92.63.98.244:26656,1004b58a7925cec67a36e41222474e44f0719ff5@5.161.124.79:39656,e977310b55bf8d50644647d0e30f272eddac12e8@65.108.58.98:36656"
#sed -i "s/^seeds *=.*/seeds = \"$seeds\"/;" $HOME/.nibid/config/config.toml
#sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/;" $HOME/.nibid/config/config.toml
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
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid

}


install
touch $HOME/.sdd_Nibiru_do_not_remove

