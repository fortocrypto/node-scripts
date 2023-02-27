#!/bin/bash

function update() {
cd $SDD_NM_HOME/muon-node-js
docker-compose down
docker-compose pull
docker-compose up -d
cd $SDD_NM_HOME
}

update
