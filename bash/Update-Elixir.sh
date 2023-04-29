#!/bin/bash

function update() {
cd $SDD_NM_HOME/.Elixir
docker kill ev
docker rm ev
docker pull elixirprotocol/validator:testnet-2
docker build . -f Dockerfile -t elixir-validator
docker run -it --name ev elixir-validator
}

update
