#!/bin/bash

function update() {
cd $SDD_NM_HOME/.Taiko/simple-taiko-node
sudo docker-compose down
sudo docker-compose pull
sudo docker-compose up -d
cd $SDD_NM_HOME
}

update
