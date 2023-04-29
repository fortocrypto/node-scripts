#!/bin/bash

function delete() {
docker kill ev
docker rm ev
rm -rf $SDD_NM_HOME/.Elixir/*
}

delete
