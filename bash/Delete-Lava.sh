#!/bin/bash

function delete() {
systemctl stop lavad
systemctl disable lavad
rm -f /etc/systemd/system/lavad.service
rm -rf $SDD_NM_HOME/.Lava/*
rm -rf ~/.lava
rm -f /usr/local/bin/lavad
}

delete
