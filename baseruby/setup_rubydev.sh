#!/bin/bash
set -e

source $BASERUBY_APP_ROOT/sources.sh

install_rvm() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io -o install_rvm.sh
    bash ./install_rvm.sh latest
}

cd $HOME

install_rvm

source "$HOME/.rvm/scripts/rvm"
