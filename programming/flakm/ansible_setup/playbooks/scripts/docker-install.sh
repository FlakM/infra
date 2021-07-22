#!/usr/bin/env bash
set -e


if ! command -v docker &> /dev/null
then
    # # taken from https://docs.docker.com/engine/install/ubuntu/
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh

    groupadd docker || true
    usermod -aG docker flakm || true
    newgrp docker || true
    docker swarm init || true
fi
