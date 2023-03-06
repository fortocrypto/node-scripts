#!/bin/bash

function delete() {
sudo $SDD_NM_HOME/.Meson/meson_cdn-linux-amd64/service stop meson_cdn
rm -rf $SDD_NM_HOME/.Meson/*
sudo ufw disable
}

delete
