#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install make clang pkg-config libssl-dev build-essential git gcc chrony curl jq ncdu bsdmainutils htop net-tools lsof fail2ban wget software-properties-common -y

cd $HOME
ver="1.19.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
go version
sudo rm -rf defund
git clone https://github.com/defund-labs/defund
cd defund
git checkout v0.2.2
make install
defundd version
export DEFUND_CHAIN="defund-private-4"

if [[ -z "$monikername" ]]; then
  read -p "Enter a moniker name for your node: " _monikername
  export monikername=$_monikername
fi

export DEFUND_MONIKER=$monikername

if [[ -z "$walletname" ]]; then
  read -p "Enter a wallet name for your node: " _walletname
  export walletname=$_walletname
fi

export DEFUND_WALLET=$walletname
source $HOME/.bash_profile
defundd init $DEFUND_MONIKER --chain-id $DEFUND_CHAIN
sed -i.bak -e 's/^seeds *=.*/seeds = '"'9f92e47ea6861f75bf8a450a681218baae396f01@94.130.219.37:26656,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656,f8fa20444c3c56a2d3b4fdc57b3fd059f7ae3127@148.251.43.226:56656,70a1f41dea262730e7ab027bcf8bd2616160a9a9@142.132.202.86:17000,e47e5e7ae537147a23995117ea8b2d4c2a408dcb@172.104.159.69:45656,74e6425e7ec76e6eaef92643b6181c42d5b8a3b8@defund-testnet-seed.itrocket.net:443'"'/' ~/.defund/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers = '"'d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:40656,a9c52398d4ea4b3303923e2933990f688c593bd8@157.90.208.222:36656,f8093378e2e5e8fc313f9285e96e70a11e4b58d5@141.94.73.39:45656,51c8bb36bfd184bdd5a8ee67431a0298218de946@57.128.80.37:26656,e26b814071e94d27aa5b23a8548d69c45221fe28@135.181.16.252:26656,72ab81b6ba22876fc7f868b58efecb05ffac9753@65.109.86.236:28656,a56c51d7a130f33ffa2965a60bee938e7a60c01f@142.132.158.4:10656,c1d2c7a810c386595e59ead21ba69555a37ac007@5.161.110.128:26656,28f14b89d10992cff60cbe98d4cd1cf84b1d2c60@88.99.214.188:26656,2b76e96658f5e5a5130bc96d63f016073579b72d@51.91.215.40:45656,11dd3e4614218bf584b6134148e2f8afae607d93@142.132.231.118:26656'"'|' $HOME/.defund/config/config.toml
curl -s https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json > ~/.defund/config/genesis.json
sed -i.bak 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0025ufetf"/g' $HOME/.defund/config/app.toml
sudo tee /etc/systemd/system/defund.service > /dev/null <<EOF
[Unit]
Description=Defund
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which defundd) start
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl restart systemd-journald
sleep 1
sudo systemctl daemon-reload
sudo systemctl enable defund
sudo systemctl restart defund

}

logo
install
touch $HOME/.sdd_Defund_do_not_remove
logo
