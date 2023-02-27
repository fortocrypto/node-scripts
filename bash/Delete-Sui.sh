#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Sui/sui
docker-compose down -v
sudo rm -rf $SDD_NM_HOME/.Sui/sui /var/sui/ /usr/local/bin/sui*
sudo rm /etc/systemd/system/suid.service
}

delete
