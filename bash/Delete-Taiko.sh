#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.Taiko/simple-taiko-node
docker compose down
cd $SDD_NM_HOME/.Taiko
rm -rf $SDD_NM_HOME/.Taiko/*
}

delete
