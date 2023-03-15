#!/bin/bash

function delete() {
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm -rf $HOME/.nolusd
#sudo rm -rf $SDD_NM_HOME/.Nolus/*
sudo rm -rf /etc/systemd/system/nolusd.service
sudo rm -rf /usr/local/bin/nolusd
}

delete
