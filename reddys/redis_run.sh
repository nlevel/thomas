#!/bin/bash
set -e

USER=redis
GROUP=redis
DAEMON=/usr/local/bin/redis-server
DAEMON_ARGS=/etc/redis/redis.conf

RUNDIR=/var/run/redis
PIDFILE=$RUNDIR/redis-server.pid

prepare() {
    mkdir -p $RUNDIR
    touch $PIDFILE
    chown $USER:$USER $RUNDIR $PIDFILE
    chmod 755 $RUNDIR

    mkdir -p $REDDYS_VAR_PATH
    mkdir -p $REDDYS_VAR_PATH/redis
    chmod -R 755 ${REDDYS_VAR_PATH}/redis
    chown -R ${USER}:${GROUP} ${REDDYS_VAR_PATH}/redis
}

start() {
    echo "Starting redis-server..."
    exec start-stop-daemon --start --quiet --oknodo --umask 007 --pidfile $PIDFILE --chuid $USER:$GROUP --exec $DAEMON -- $DAEMON_ARGS
}

prepare
start
