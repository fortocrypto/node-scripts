#!/bin/bash

function delete() {
sudo systemctl stop kyved
sudo systemctl disable kyved
rm /etc/systemd/system/kyved.service
rm /usr/local/bin/kyved
rm -r $SDD_NM_HOME/.Kyve/*
rm -r $HOME/.kyve
}

delete
