#!/bin/bash
set -e

source $BASERUBY_APP_ROOT/sources.sh

setuser $RUBYDEV_USER $RUBYDEV_APP_ROOT/setup_rubydev.sh

cleanup
