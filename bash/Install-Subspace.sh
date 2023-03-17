#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install tar curl git ufw ca-certificates ocl-icd-opencl-dev libopencl-clang-dev libgomp1 -y
cd $SDD_NM_HOME/.Subspace
wget -O subspace-cli https://github.com/subspace/subspace-cli/releases/download/v0.1.9-alpha/subspace-cli-Ubuntu-x86_64-v0.1.9-alpha
sudo chmod +x subspace-cli
sudo mv subspace-cli /usr/local/bin/
sudo rm -rf $HOME/.config/subspace-cli
/usr/local/bin/subspace-cli init
source ~/.bash_profile
sleep 1
echo "[Unit]
Description=Subspace Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/subspace-cli farm --verbose
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/subspaced.service
mv $HOME/subspaced.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced
sudo systemctl restart subspaced
}

install
