#!/bin/bash
set -e

setup_user() {
    groupadd -g $GITTI_USER_ID $GITTI_USER
    useradd -g $GITTI_USER -u $GITTI_USER_ID -d $GITTI_HOME -m -r -s /usr/bin/git-shell $GITTI_USER

    # set a long random password to unlock the git user account
    usermod -p `dd if=/dev/urandom bs=1 count=30 | uuencode -m - | head -2 | tail -1` $GITTI_USER
}

configure_sshd() {
    mv /etc/service.disabled/sshd /etc/service/sshd
    rm -f /etc/service/sshd/down
    /etc/my_init.d/00_regen_ssh_host_keys.sh -f

    sed -i -e 's/.*LogLevel.*/LogLevel VERBOSE/' -e 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i -e 's/#UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
    sed -i -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

    rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic
    ln -fs /dev/null /run/motd.dynamic
}

cleanup() {
    apt-get autoremove --purge
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

cd /tmp
setup_user
configure_sshd

cd /
cleanup
