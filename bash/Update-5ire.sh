#!/bin/bash

function logo() {
bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function update() {

}

logo
if [ -f $HOME/.sdd_5ire_do_not_remove ]; then
  update
  logo
fi
