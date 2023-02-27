#!/bin/bash

function delete() {
cd
sudo $HOME/meson_cdn-linux-amd64/service stop meson_cdn
rm -rf meson_cdn-linux-amd64
sudo ufw disable
}

delete
