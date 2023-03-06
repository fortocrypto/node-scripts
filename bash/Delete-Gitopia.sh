#!/bin/bash

function delete() {
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $SDD_NM_HOME/.Gitopia/* -rf
sed -i '/GITOPIA_/d' ~/.bash_profile
sudo ufw reset
sudo ufw disable
}

delete
