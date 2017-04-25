#!/bin/bash
set -e

REDIS_SRC_PATH=/usr/src/redis

# Originally copied from:
#
# https://github.com/docker-library/redis/blob/master/3.2/Dockerfile
#
download_latest_redis() {
    cd /tmp
    [ ! -f redis.tar.gz ] && curl -ko redis.tar.gz $LATEST_REDIS_DOWNLOAD_URL
    ls -fl redis.tar.gz
    echo "$LATEST_REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c -
    mkdir -p $REDIS_SRC_PATH
    tar -xzf redis.tar.gz -C $REDIS_SRC_PATH --strip-components=1
    rm redis.tar.gz
}

install_latest_redis() {
    cd $REDIS_SRC_PATH
    make -C $REDIS_SRC_PATH
    make -C $REDIS_SRC_PATH install
    rm -r $REDIS_SRC_PATH
    cd /
}

setup_reddys_path() {
    mkdir -p $REDDYS_APP_PATH
}

download_latest_redis
install_latest_redis
setup_reddys_path
