#!/bin/bash
set -e

CONSUL_INSTALL_PATH=/usr/local/bin

download_and_install() {
    cd /tmp
    [ ! -f consul.gz ] && curl -sko consul.gz $CONSUL_DOWNLOAD_URL
    ls -fl consul.gz
    echo "$CONSUL_DOWNLOAD_SHA1 consul.gz" | sha1sum -c -
    gunzip consul.gz
    chmod +x consul
    cp consul $CONSUL_INSTALL_PATH

    rm -rf consul
    rm -rf consul.gz

    echo "== Installed consul! =="
    $CONSUL_INSTALL_PATH/consul version
}

setup_service() {
    mkdir -p /etc/service/konsol
    mkdir -p $CONSUL_VAR_DIR
    mkdir -p $CONSUL_CONFIG_DIR
}

disable_sshd() {
    rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
}

cleanup() {
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

cd /tmp
download_and_install

cd /tmp
disable_sshd
setup_service

cd /
cleanup
