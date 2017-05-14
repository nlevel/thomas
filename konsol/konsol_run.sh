#!/bin/bash
set -e

CONSUL_ARGS="agent -data-dir=${CONSUL_VAR_DIR} -config-dir=${CONSUL_CONFIG_DIR} -bind=0.0.0.0 -client=0.0.0.0"

prepare_data_dir() {
    mkdir -p "${CONSUL_VAR_DIR}"
    chmod -R 755 "${CONSUL_VAR_DIR}"
    chown -R root:root "${CONSUL_VAR_DIR}"
}

prepare_data_dir

if [[ ! -z "${CONSUL_ADVERTISE}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -advertise=${CONSUL_ADVERTISE}"
fi

if [[ ! -z "${CONSUL_SERVER}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -server"
fi

if [[ ! -z "${CONSUL_BOOTSTRAP_EXPECT}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -bootstrap-expect=${CONSUL_BOOTSTRAP_EXPECT}"
fi

if [[ ! -z "${CONSUL_JOIN}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -join=${CONSUL_JOIN}"
fi

if [[ ! -z "${CONSUL_DOMAIN}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -domain=${CONSUL_DOMAIN}"
fi

if [[ ! -z "${CONSUL_NODE}" ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} -node=${CONSUL_NODE}"
fi

# allow arguments to be passed to consul
if [[ ${1:0:1} = '-' ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} $@"
    set --
elif [[ ${1} == consul || ${1} == $(which consul) ]]; then
    CONSUL_ARGS="${CONSUL_ARGS} ${@:2}"
    set --
fi

# default behaviour is to launch consul
if [[ -z "${1}" ]]; then
    echo "Starting consul..."
    echo "consul ${CONSUL_ARGS}"

    cd "${CONSUL_VAR_DIR}"
    exec $(which consul) ${CONSUL_ARGS}
else
    exec "$@"
fi
