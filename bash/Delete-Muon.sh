#!/bin/bash

function delete() {
cd $SDD_NM_HOME/muon-node-js
muon_backup
docker-compose down
cd $HOME
rm -rf $SDD_NM_HOME/muon-node-js
}

delete
