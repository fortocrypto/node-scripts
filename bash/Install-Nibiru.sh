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

NODE=NIBIRU
NODE_HOME=$HOME/.nibid
BRANCH=v0.19.2
GIT="https://github.com/NibiruChain/nibiru.git"
GIT_FOLDER=nibiru
BINARY=nibid
GENESIS="https://raw.githubusercontent.com/Pa1amar/testnets/main/nibiru/nibiru-itn-1/genesis.json"
ADDRBOOK="https://api.nodes.guru/nibiru_addrbook.json"
CHAIN_ID=nibiru-itn-1
PEERS="ac163da500a9a1654f5bf74179e273e2fb212a75@65.108.238.147:27656,abab2c6f45fa865dc61b2757e21c5d2244e5bacb@213.202.218.55:26656,fe17db7c9a5f8478a2d6a39dbf77c4dc2d6d7232@5.75.189.135:26656,baff3597ebd19ce273b7c0b56e2d50a8964d1423@65.109.90.166:26656,ca6213c897bd8400d8d01b947a541db85ebb2d96@51.89.199.49:36656,63256b5937ac438e3b21b570a07ace6ddc3bd0c6@194.163.182.122:39656,c1b40d056e4260a9fa9d1142af1adbeec5039599@142.132.202.50:46656,ea44a000ee4df9d722a90fdf41b3990e738bdda0@65.109.235.95:26656,7e75b2249d088a4dfc3b33f386c316cb47366d2b@195.3.221.48:11656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,2484b3b0912815869317e1da43a409b9ffd6653e@154.12.244.128:26656,9946c87d01312752d26fe0ceef4f4e24707f8144@65.109.88.178:27656,d327bb6b997a32aaa7dae5673e9a9cbad487ad09@104.156.250.70:26656,4f1af4f62f76c095d844384a3dfa1ad76ad5c078@65.108.206.118:60656,6052d09554a442f22f71c33dbc5f25bee538e087@65.109.82.249:28656,c4124e6623529b31b8c535be1ea8835aa7ff51b0@51.79.77.103:28656,2dce4b0844754b467ae40c9d6360ac51836fadca@135.181.221.186:29656,c8907a13b012e7a937cfe7d624b0fbe7ef3508b2@194.163.160.155:26656,0ebf64601e93d0e5304da8b7d3deb96d7d7cbcf8@176.120.177.123:26656,30e14f66fc44a55a51f36693afd754283c668953@65.108.200.60:11656,fa5c730d842aff05c3761d9c1b06107340ac7651@65.108.232.238:11656,f01ad3a75b255226499df9183ac2ebc0a40a9e05@46.4.53.207:33656,81a8383eefae628ae4bc400d52d49adfb11cb76a@65.108.108.52:11656,1c548375968f0abfac3733cae9f592468c988bf9@46.4.53.209:33656,f4a6bcbd4af5cfd82ee3a40c54800176e33e9477@31.220.79.15:26656,b03d1ce3e97984a8b8a63a7a6ec6c5d196d81436@46.4.53.208:33656,e74f1204d65d0264547e2c2d917c23c39fcff774@95.217.107.96:36656,b316ff6b5a0715732fa02f990db94aef39e758b3@148.251.88.145:10156,79e2bfc202e39ba2a168becc4c75cb6a56803e38@135.181.57.104:11656,22d5b4919850ad71ad0a1bf7979c7dba53960689@192.9.134.157:27656,2686c58fc276fff2956bf1b10736244737f84c9b@178.208.86.44:26656,a3a344c1732c507f40931778225f919004392e94@52.204.188.236:26656,84d888be939b738d343db0613d4cc50a33f36beb@158.101.208.86:26656,21ad250f917fafcd9bca8ea223558dffc6bd75c4@38.242.205.18:26656,1848442cbab24bc7123ad2dec2464661b5bc92c1@94.190.90.38:28656,e9b25db508b31cb9d48b1f0b67147faf8c2b7b0b@65.108.199.206:27656"

if [[ -z "$validatorname" ]]; then
  read -p "Enter your nibiru node validator name : " _validatorname
  export validatorname=$_validatorname
fi

echo 'export VALIDATOR='\"$validatorname\" >> $HOME/.bash_profile
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
cd
VERSION=1.19.6
wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version
rm -rf $HOME/$GIT_FOLDER
git clone $GIT
cd $GIT_FOLDER && git checkout $BRANCH
make build
sudo mv $HOME/$GIT_FOLDER/build/$BINARY /usr/local/bin/ || exit
sleep 1
$BINARY init "$VALIDATOR" --chain-id $CHAIN_ID
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn.nibiru.fi/$CHAIN_ID/seeds)'"|g' $NODE_HOME/config/config.toml
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $NODE_HOME/config/config.toml
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025unibi\"/" $NODE_HOME/config/app.toml
sed -i 's|enable =.*|enable = true|g' $NODE_HOME/config/config.toml
sed -i 's|rpc_servers =.*|rpc_servers = "'$(curl -s https://networks.itn.nibiru.fi/$CHAIN_ID/rpc_servers)'"|g' $NODE_HOME/config/config.toml
sed -i 's|trust_height =.*|trust_height = "'$(curl -s https://networks.itn.nibiru.fi/$CHAIN_ID/trust_height)'"|g' $NODE_HOME/config/config.toml
sed -i 's|trust_hash =.*|trust_hash = "'$(curl -s https://networks.itn.nibiru.fi/$CHAIN_ID/trust_hash)'"|g' $NODE_HOME/config/config.toml
wget $GENESIS -O $NODE_HOME/config/genesis.json
$BINARY tendermint unsafe-reset-all
wget $ADDRBOOK -O $NODE_HOME/config/addrbook.json
echo "[Unit]
Description=$NODE Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/$BINARY start
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/$BINARY.service
sudo mv $HOME/$BINARY.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl restart $BINARY

}

logo
install
touch $HOME/.sdd_Nibiru_do_not_remove
logo
