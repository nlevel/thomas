#!/bin/bash
set -e

source $BASERUBY_APP_ROOT/sources.sh
source "$HOME/.rvm/scripts/rvm"

RVM_ARCHIVES="$HOME/.rvm/archives"

download_assets() {
    mkdir -p $RVM_ARCHIVES
    cd $RVM_ARCHIVES

    if [ ! -z "$ASSETS_RUBY" ]; then
        filename="${ASSETS_RUBY##*/}"
        dest_path="${RVM_ARCHIVES}/${filename}"

        echo "Downloading ${filename} -> ${dest_path}"
        curl -k -o "${dest_path}" "$ASSETS_RUBY"
        ls -fl ${dest_path}
        echo "$ASSETS_RUBY_SHA1SUM ${filename}" | sha1sum -c -
    fi

    cd $HOME
}

setup_rubies() {
    rvm install $RUBY_INSTALL_VERSION
    rvm $RUBY_INSTALL_VERSION do gem install bundler -v $BUNDLER_INSTALL_VERSION --no-ri --no-rdoc
    rvm alias create default $RUBY_INSTALL_VERSION
}

rvm_cleanup() {
    rvm cleanup all
    rm -Rf "$HOME/.rvm/archives"
}

cd $HOME
download_assets
setup_rubies
rvm_cleanup
