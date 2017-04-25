#!/bin/bash
set -e

create_log_dir() {
    mkdir -p ${SQUID_LOG_DIR}
    chmod -R 755 ${SQUID_LOG_DIR}
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
    mkdir -p ${SQUID_CACHE_DIR}
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

    mkdir -p ${SQUID_INTERNAL_CACHE_DIR}
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_INTERNAL_CACHE_DIR}
}

check_for_stale_pid() {
    if [ -e ${SQUID_PID_FILE} ] && kill -0 `cat ${SQUID_PID_FILE}`; then
        SQUID_PID=$(cat ${SQUID_PID_FILE})
        echo "Squid is somehow running at ${SQUID_PID}. Killing it."

        kill $SQUID_PID
        sleep 3
    fi

    rm -f ${SQUID_PID_FILE}
}

create_log_dir
create_cache_dir
check_for_stale_pid

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
    EXTRA_ARGS="$@"
    set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
    EXTRA_ARGS="${@:2}"
    set --
fi



# default behaviour is to launch squid
if [[ -z ${1} ]]; then
    if [ "${SQUID_CONF}" eq "internal" ]; then
        SQUID_CONF="squid.internal.conf"
    fi

    if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
        sleep 5
        echo "Initializing cache..."
        $(which squid) -N -f /etc/squid/$SQUID_CONF -z
    fi

    if [[ ! -d ${SQUID_INTERNAL_CACHE_DIR}/00 ]]; then
        sleep 5
        echo "Initializing internal cache..."
        $(which squid) -N -f /etc/squid/$SQUID_CONF -z
    fi

    echo "Starting squid..."
    exec $(which squid) -f /etc/squid/$SQUID_CONF -sNYd 1 ${EXTRA_ARGS}
else
    exec "$@"
fi
