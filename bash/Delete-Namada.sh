#!/bin/bash

function delete() {
cd $HOME
sudo systemctl stop namadad
sudo systemctl disable namadad
sudo rm /etc/systemd/system/namadad.service
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald
sudo rm /usr/local/bin/namada
sudo rm /usr/local/bin/namada[c,n,w]
sudo rm /usr/local/bin/tendermint
rm -rf $SDD_NM_HOME/.Namada/*
}

delete
