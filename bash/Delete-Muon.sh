#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Muon
docker-compose down
cd $HOME
rm -rf $SDD_NM_HOME/.Muon/*
}

delete
