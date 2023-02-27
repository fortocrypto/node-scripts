#!/bin/bash

function update() {
cd $SDD_NM_HOME/sui
sudo apt update && sudo apt upfrade -y
}

update
