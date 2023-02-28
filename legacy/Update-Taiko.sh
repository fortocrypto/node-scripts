#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {
sudo apt update && sudo apt upgrade -y
}


if [ -f $HOME/.sdd_Taiko_do_not_remove ]; then
  update
  
fi
