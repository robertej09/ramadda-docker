#!/bin/bash
set -x

# run this script as sudo

# scriptified version of https://docs.docker.com/engine/installation/linux/ubuntulinux/

groupadd docker

usermod -aG docker unidata

apt-get -qq update

apt-get -qq install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" |
tee --append /etc/apt/sources.list.d/docker.list  > /dev/null

apt-get -qq update

apt-get -qq purge lxc-docker

apt-cache policy docker-engine

apt-get -qq update

apt-get install linux-image-extra-$(uname -r)

apt-get install apparmor

apt-get -qq update

apt-get -qq install docker-engine

service docker start

# Get docker-compose too
curl -L \
  https://github.com/docker/compose/releases/download/1.7.0/\
docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
