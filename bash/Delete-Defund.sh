#!/bin/bash

function delete() {
sudo systemctl stop defund
sudo systemctl disable defund
sudo rm -rf /etc/systemd/system/defund.service
sudo systemctl daemon-reload
rm -rf $SDD_NM_HOME/.Defund/*
rm -rf $HOME/.defund
}

delete
