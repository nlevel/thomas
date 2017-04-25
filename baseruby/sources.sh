#!/bin/bash
set -e

DEBIAN_FRONTEND=noninteractive

RUBYDEV_USER=rubydev
RUBYDEV_UID=1111
RUBYDEV_HOME="/home/rubydev"

RVM_EXEC="$RUBYDEV_HOME/.rvm/bin/rvm-exec"

cleanup() {
    apt-get autoremove --purge
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}
