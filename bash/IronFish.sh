#!/bin/bash

function logo() {
  bash <(curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/logo.sh)
}

function install() {
sudo apt update && sudo apt upgrade -y
sudo apt install curl git


curl -s https://raw.githubusercontent.com/sorkand1/tools/main/install_docker.sh | bash
echo "alias ironfish='docker exec ironfish ./bin/run'" >> ~/.profile
source ~/.profile
sudo tee <<EOF >/dev/null $HOME/docker-compose.yaml
version: "3.3"
services:
 ironfish:
  container_name: ironfish
  image: ghcr.io/iron-fish/ironfish:latest
  restart: always
  entrypoint: sh -c "sed -i 's%REQUEST_BLOCKS_PER_MESSAGE.*%REQUEST_BLOCKS_PER_MESSAGE = 5%' /usr/src/app/node_modules/ironfish/src/syncer.ts && apt update > /dev/null && apt install curl -y > /dev/null; ./bin/run start"
  healthcheck:
   test: "curl -s -H 'Connection: Upgrade' -H 'Upgrade: websocket' http://127.0.0.1:9033 || killall5 -9"
   interval: 180s
   timeout: 180s
   retries: 3
  volumes:
   - $HOME/.ironfish:/root/.ironfish
EOF
docker-compose pull && docker-compose up -d

if [[ -z "$ironfishname" ]]; then
  read -p "Придумай имя для кошелька: " _ironfishname
  export ironfishname=$_ironfishname
fi

docker exec ironfish ./bin/run wallet:create $ironfishname

if [[ -z "$ironfishname" ]]; then
  read -p "Придумай имя для кошелька: " _ironfishname
  export ironfishname=$_ironfishname
fi

docker exec ironfish ./bin/run wallet:use $ironfishname

if [[ -z "$ironfishname" ]]; then
  read -p "Придумай имя для кошелька: " _ironfishname
  export ironfishname=$_ironfishname
fi

docker exec ironfish ./bin/run config:set nodeName $ironfishname

if [[ -z "$ironfishname" ]]; then
  read -p "Придумай имя для кошелька: " _ironfishname
  export ironfishname=$_ironfishname
fi

docker exec ironfish ./bin/run config:set blockGraffiti $ironfishname
docker exec ironfish ./bin/run config:set minerBatchSize 60000
docker exec ironfish ./bin/run config:set enableTelemetry true
docker exec ironfish ./bin/run status
docker exec ironfish ./bin/run wallet:address
docker-compose restart

}

function update() {
docker-compose down
docker-compose pull
docker-compose run --rm --entrypoint "./bin/run migrations:start" ironfish
docker-compose up -d
}

logo
if [ -f sdd_co_donotdelete_IronFish ]; then
  update
else
  install
  touch sdd_co_donotdelete_IronFish
fi
logo
