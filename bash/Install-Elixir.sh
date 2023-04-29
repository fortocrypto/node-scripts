#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git apt-transport-https ca-certificates software-properties-common wget -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
cd $SDD_NM_HOME/.Elixir
wget https://files.elixir.finance/Dockerfile
sed -i.bak -e "s|^ENV ADDRESS *=.*|ENV ADDRESS=$adress|" $SDD_NM_HOME/.Elixir/Dockerfile
sed -i.bak -e "s|^ENV PRIVATE_KEY *=.*|ENV PRIVATE_KEY=$private_key|" $SDD_NM_HOME/.Elixir/Dockerfile
sed -i.bak -e "s|^ENV VALIDATOR_NAME *=.*|ENV VALIDATOR_NAME=$validator_name|" $SDD_NM_HOME/.Elixir/Dockerfile
docker build . -f Dockerfile -t elixir-validator
docker run -dit --name ev elixir-validator
}

install
