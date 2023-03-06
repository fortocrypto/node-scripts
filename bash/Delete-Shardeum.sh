#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Shardeum/.shardeum
docker compose down
cd $HOME
rm -Rf cd $SDD_NM_HOME/.Shardeum/*
}

delete
