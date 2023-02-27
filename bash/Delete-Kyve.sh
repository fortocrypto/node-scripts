#!/bin/bash

function delete() {
sudo systemctl stop kyved
sudo systemctl disable kyved
cd $HOME
rm /etc/systemd/system/kyved.service
rm /usr/local/bin/kyved
rm -r $SDD_NM_HOME/kyve
rm -r $HOME/.kyve
}

delete
