#!/bin/bash

function delete() {
sudo systemctl stop subspaced
sudo systemctl disable subspaced
sudo rm -rf /etc/systemd/system/subspaced.service
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald
sudo rm -rf $SDD_NM_HOME/.Subspace/*
sudo rm -rf /usr/local/bin/subspace-cli
}

delete
