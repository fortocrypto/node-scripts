#!/bin/bash

function delete() {
cd $SDD_NM_HOME/.IronFish
docker-compose down
rm $SDD_NM_HOME/.IronFish/docker-compose.yaml
}

delete
