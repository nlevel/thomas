#!/bin/bash

configure() {
    mkdir -p $SQUID_VAR_DIR
    mv /etc/squid/squid.conf /etc/squid/squid.conf.dist
    rm -rf /var/lib/apt/lists/*
}

apply_backward_compatibility_fixes() {
    if [[ -f /etc/squid/squid.user.conf ]]; then
        rm -rf /etc/squid/squid.conf
        ln -sf /etc/squid/squid.user.conf /etc/squid/squid.conf
    fi
}

setup_service() {
    mkdir -p /etc/service/squidy
}

disable_sshd() {
    rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
}

cleanup() {
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

cd /tmp
configure
apply_backward_compatibility_fixes
disable_sshd
setup_service

cd /
cleanup
