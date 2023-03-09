#!/bin/bash

function delete() {
sudo $SDD_NM_HOME/.Gaga/app-linux-amd64/app service stop
sudo rm -rf $SDD_NM_HOME/.Gaga/*
}

delete
