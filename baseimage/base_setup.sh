#!/bin/bash
set -e

source $BASEIMAGE_PATH/base_functions.sh

disable_unused_services() {
    mkdir -p /etc/service.disabled
    mv /etc/service/sshd /etc/service.disabled
    mv /etc/service/cron /etc/service.disabled
}

disable_unused_services

mkdir -p /etc/my_init.d
