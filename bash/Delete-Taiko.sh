#!/bin/bash

function delete() {
cd $SDD_NM_HOME/simple-taiko-node
sudo docker-compose down
cd $SDD_NM_HOME
rm -f .env
rm -rf simple-taiko-node
cd $HOME
}

delete
