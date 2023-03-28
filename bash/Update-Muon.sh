#!/bin/bash

function update() {
cd $SDD_NM_HOME/.Muon
docker cp muon-node:/usr/src/muon-node-js/.env ~/backup.env
docker stop muon-node redis mongo
docker rm muon-node redis mongo
cd $SDD_NM_HOME/.Muon
rm muon-node-js -rf
curl -o docker-compose.yml https://raw.githubusercontent.com/muon-protocol/muon-node-js/testnet/docker-compose-pull.yml
docker-compose pull
docker-compose up -d
docker cp ~/backup.env muon-node:/usr/src/muon-node-js/backup.env
docker exec -it muon-node ./node_modules/.bin/ts-node ./src/cmd keys restore backup.env
docker restart muon-node
}

update
