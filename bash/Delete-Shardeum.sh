#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.shardeum
docker compose down
cd $HOME
rm -Rf $SDD_NM_HOME/.shardeum
}

delete
