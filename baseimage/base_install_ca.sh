#!/bin/bash
set -e

source $BASEIMAGE_PATH/base_functions.sh

install_ca
update-ca-certificates
