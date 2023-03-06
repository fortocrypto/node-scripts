#!/bin/bash

function install() {
sudo apt --fix-broken install
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get install -f -y
sudo apt install curl git -y
curl -s https://raw.githubusercontent.com/fortocrypto/node-scripts/master/bash/Install-Docker.sh | bash
echo "alias ironfish='docker exec ironfish ./bin/run'" >> ~/.profile
source ~/.profile
sleep 1
available_ports=$(ss -Htan | awk '{print $4}' | cut -d ':' -f 2 | grep -v -E '^(0|1|5|6|7|8|9)' | sort -un)
selected_ports=$(echo "$available_ports" | shuf -n 2)
i=1
for port in $selected_ports; do
varname="var$i"
eval $varname=$port
((i++))
done
sudo tee <<EOF >/dev/null $SDD_NM_HOME/.IronFish/docker-compose.yaml
version: "3.3"
services:
 ironfish:
  container_name: ironfish
  image: ghcr.io/iron-fish/ironfish:latest
  restart: always
  entrypoint: sh -c "sed -i 's%REQUEST_BLOCKS_PER_MESSAGE.*%REQUEST_BLOCKS_PER_MESSAGE = 5%' /usr/src/app/node_modules/ironfish/src/syncer.ts && apt update > /dev/null && apt install curl -y > /dev/null; ./bin/run start"
  healthcheck:
   test: "curl -s -H 'Connection: Upgrade' -H 'Upgrade: websocket' http://127.0.0.1:$var1 || killall5 -9"
   interval: 180s
   timeout: 180s
   retries: 3
  volumes:
   - $SDD_NM_HOME/.IronFish:$SDD_NM_HOME/.IronFish
EOF
cd $SDD_NM_HOME/.IronFish
docker-compose pull && docker-compose up -d
docker exec ironfish ./bin/run wallet:create $ironfishname
docker exec ironfish ./bin/run wallet:use $ironfishname
docker exec ironfish ./bin/run config:set nodeName $ironfishname
docker exec ironfish ./bin/run config:set blockGraffiti $ironfishname
docker exec ironfish ./bin/run config:set minerBatchSize 60000
docker exec ironfish ./bin/run config:set enableTelemetry true
docker exec ironfish ./bin/run status
docker exec ironfish ./bin/run wallet:address
docker-compose restart
cd $SDD_NM_HOME
}

install
