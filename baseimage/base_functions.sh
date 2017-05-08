#!/bin/bash
set -e

CA_EXTRAS=/usr/local/share/ca-certificates

install_ca() {
    mkdir -p ${CA_EXTRAS}
    cd ${CA_EXTRAS}

    IFS=';' read -ra ALL_CA <<< "${CA_URLS}"
    for CA_URL in "${ALL_CA[@]}"; do
        filename="${CA_URL##*/}"
        dest_path="${CA_EXTRAS}/${filename}"

        echo "Downloading ${filename} -> ${dest_path}"
        curl -ko ${dest_path} ${CA_URL}
        ls -fl ${dest_path}
    done
}
