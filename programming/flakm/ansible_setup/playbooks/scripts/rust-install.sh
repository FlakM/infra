#!/usr/bin/env bash
set -e

if ! command -v rustc &> /dev/null
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh
    sh rustup.sh -y
    source $HOME/.cargo/env

    cargo install bat proximity-sort fd rg
    bat --version
    # needed for itc vpn
    cargo install --git https://github.com/FlakM/google_auth.git
fi
