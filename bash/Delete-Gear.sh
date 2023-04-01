#!/bin/bash

function delete() {
rm -rf $SDD_NM_HOME/.Gear/*
sudo systemctl stop gear-node
sudo systemctl disable gear-node
sudo rm -rf $HOME/.local/share/gear
sudo rm /etc/systemd/system/gear-node.service
sudo rm /usr/bin/gear
}

delete
