#!/bin/sh

setup_login() {
    # prevent login banners
    touch $GITTI_HOME/.hushlogin
}

prepare_home_path() {
    chmod -R u+rw ${GITTI_HOME}
    chmod -R u+rw ${GITTI_HOME}/.ssh
    chown -R ${GITTI_USER}:${GITTI_USER} ${GITTI_HOME}
    chown -R ${GITTI_USER}:${GITTI_USER} ${GITTI_HOME}/.ssh
}

setup_login
prepare_home_path
