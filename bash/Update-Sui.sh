#!/bin/bash

function update() {
cd $SDD_NM_HOME/.Sui/sui
sudo apt update && sudo apt upfrade -y
}

update
