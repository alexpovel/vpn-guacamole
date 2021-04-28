#!/bin/sh
set -eu

apt-get update

# Docker Debian installation:
apt-get install --yes --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Delete if exists from a previous run, else `gpg` might fail:
rm /usr/share/keyrings/docker-archive-keyring.gpg || true

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --batch --no-tty --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update from the repo we just added
apt-get update

apt-get install --yes \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    openvpn \
    openconnect \
    python3-pip

# Could also try `docker stack` without the `docker-compose` mess, but whatever...
python3 -m pip install docker-compose
