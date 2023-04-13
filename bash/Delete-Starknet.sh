#!/bin/bash

function delete() {
sudo systemctl stop starknetd
sudo systemctl disable starknetd
sudo rm -rf /etc/systemd/system/starknetd.service
sudo systemctl daemon-reload
rm -rf $SDD_NM_HOME/.Starknet/*
}

delete
