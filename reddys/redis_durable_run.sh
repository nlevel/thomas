#!/bin/bash
set -e

USER=redis
GROUP=redis
DAEMON=/usr/local/bin/redis-server
DAEMON_ARGS=/etc/redis/redis-durable.conf

RUNDIR=/var/run/redis
PIDFILE=$RUNDIR/redis-durable-server.pid

prepare() {
    mkdir -p $RUNDIR
    touch $PIDFILE
    chown $USER:$USER $RUNDIR $PIDFILE
    chmod 755 $RUNDIR

    mkdir -p $REDDYS_VAR_PATH
    mkdir -p $REDDYS_VAR_PATH/redis_durable
    chmod -R 755 ${REDDYS_VAR_PATH}/redis_durable
    chown -R ${USER}:${GROUP} ${REDDYS_VAR_PATH}/redis_durable
}

start() {
    echo "Starting redis-durable-server..."
    exec start-stop-daemon --start --quiet --oknodo --umask 007 --pidfile $PIDFILE --chuid $USER:$GROUP --exec $DAEMON -- $DAEMON_ARGS
}

prepare

if [[ ! -z "${REDDYS_DURABLE_ENABLE}" ]]; then
    start
else
    echo "WARN: Redis durable not enabled. Ignoring."
    sleep infinity
fi
