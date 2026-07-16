#!/bin/bash

. /etc/os-release


# Add the backports repo (if on trixte and its is not there)

if [[ "$VERSION_CODENAME" == "trixie" && ! -e "/etc/apt/sources.list.d/debian-backports.sources" ]]; then
cat > /etc/apt/sources.list.d/debian-backports.sources << EOF
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: trixie-backports
Components: main
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
fi

yes-no() {
    local msg="$1"
    local def="$2"
    read -p "$msg" -n 1 -r
    echo
    # Check if the user says yes or no
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "y"
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "n"
    else
        echo "$def"
    fi
}

yes-no "this WILL erase all files in the hypr, kitty, swaync and waybar config folders, continue? y/N: " "n"