#!/bin/bash

function delete() {
rm -rf $SDD_NM_HOME/.Goracle/*
sudo rm -rf /usr/bin/goracle
}

delete
