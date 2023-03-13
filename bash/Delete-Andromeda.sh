#!/bin/bash

function delete() {
sudo systemctl stop andromedad
sudo systemctl disable andromedad
sudo rm -rf $HOME/.andromedad
sudo rm -rf $SDD_NM_HOME/.Andromeda/*
sudo rm -rf /etc/systemd/system/andromedad.service
sudo rm -rf /usr/local/bin/andromedad
}

delete
