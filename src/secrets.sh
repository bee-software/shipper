#!/bin/bash

send_secrets() {
    local shipping_label=$1

    local destination=$(destination_from_label ${shipping_label})
    local secrets_directory="${shipping_label}/secrets"

    if [ -d ${secrets_directory} ]; then
        for service in $(ls "${shipping_label}/secrets"); do
          echo "Sending secrets to service ${service}" > /dev/stderr
          tar -C "${shipping_label}/secrets/${service}" -cf - $(ls "${shipping_label}/secrets/${service}") | \
            run_in_container ${shipping_label} ${service} tar -C /dev/shm -xf -
        done
    fi
}
