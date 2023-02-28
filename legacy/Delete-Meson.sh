#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function delete() {

rm -f $HOME/.sdd_Meson_do_not_remove
cd
sudo $HOME/meson_cdn-linux-amd64/service stop meson_cdn
rm -rf meson_cdn-linux-amd64
sudo ufw disable
}


if [ -f $HOME/.sdd_Meson_do_not_remove ]; then
  delete
  
fi
