#!/bin/bash

function delete() {
sudo systemctl stop fleek
sudo rm -rf /etc/systemd/system/fleek.service
sudo rm -rf $SDD_NM_HOME/.Fleek/ursa
}

delete
