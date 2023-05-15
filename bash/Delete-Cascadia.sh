#!/bin/bash

function delete() {
systemctl stop cascadiad
systemctl disable cascadiad
rm -rf /etc/systemd/system/cascadiad.service
rm -rf $SDD_NM_HOME/.Taiko/*
}

delete
