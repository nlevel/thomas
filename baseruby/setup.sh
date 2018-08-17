#!/bin/bash
set -e

source $BASERUBY_APP_ROOT/sources.sh

add_user() {
    useradd -U -m -u $RUBYDEV_UID -d $RUBYDEV_HOME -s /bin/bash $RUBYDEV_USER
    echo "$RUBYDEV_USER ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
}

prepare_app_root() {
    chown -R $RUBYDEV_USER:$RUBYDEV_USER $BASERUBY_APP_ROOT
}

setup_rubydev() {
    setuser $RUBYDEV_USER $BASERUBY_APP_ROOT/setup_rubydev.sh
}

add_user
prepare_app_root
setup_rubydev
cleanup
