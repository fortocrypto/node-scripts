#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Sui/sui
docker-compose down -v
sudo rm -rf $SDD_NM_HOME/.Sui/* /var/sui/ /usr/local/bin/sui*
}

delete
