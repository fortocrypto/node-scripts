#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Muon/muon-node-js
muon_backup
docker-compose down
cd $HOME
rm -rf $SDD_NM_HOME/.Muon/*
}

delete
