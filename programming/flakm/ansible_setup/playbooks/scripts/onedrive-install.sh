#!/usr/bin/env bash
set -e

if ! command -v onedrive &> /dev/null
then
    add-apt-repository -y ppa:yann1ck/onedrive
    apt install onedrive -y

    MOUNT_POINT="$1/rave_passwords"
    mkdir -p "$MOUNT_POINT"
    sudo chown flakm:flakm "$MOUNT_POINT"
fi