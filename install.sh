#!/bin/bash

clear

local IS_RUN="1"

if [[ ! -n "$IS_RUN" ]]; then
    echo "N223580IsMe's Dofile installer"
fi

# See if the user is root and if so, re-run with sudo
if [[ $(id -u) != "0" ]]; then
    echo "You did not run the installer with sudo, asking for perms." 
    sudo "$0"
fi

. /etc/os-release

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "$ID" in 
    debian)
        $DIR/installer/debian.sh
        ;;
    arch)
        $DIR/installer/arch.sh
        ;;
    *)
        echo "Disto not recognized, install the stuff yourself and copy the files yourself"
esac