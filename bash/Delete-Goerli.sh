#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Goerli/node
docker compose down
cd $SDD_NM_HOME/.Goerli
rm -rf $SDD_NM_HOME/.Goerli/*
}

delete
