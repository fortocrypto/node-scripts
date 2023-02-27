#!/bin/bash

function delete() {
cd $HOME
systemctl stop lavad
systemctl disable lavad
rm -f /etc/systemd/system/lavad.service
rm -rf $SDD_NM_HOME/GHFkqmTzpdNLDd6T
rm -rf .lava
rm -f /usr/local/bin/lavad
}

delete
