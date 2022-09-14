#!/bin/bash
set -e
set -o pipefail

DRY_RUN="${DRY_RUN:-"0"}"

source $(dirname $0)/src/config.sh
source $(dirname $0)/src/remote.sh
source $(dirname $0)/src/templating.sh
source $(dirname $0)/src/docker_ready.sh
source $(dirname $0)/src/docker_images.sh
source $(dirname $0)/src/docker_compose.sh
source $(dirname $0)/src/shipping.sh
source $(dirname $0)/src/hooks.sh
source $(dirname $0)/src/secrets.sh
source $(dirname $0)/src/versioning.sh

fail() {
    echo $@ > /dev/stderr
    exit 1
}

run() {
    if [ ${DRY_RUN} == "1" ]; then
        : "${@}"
    else
        "${@}"
    fi
}

ship() {
    local shipping_label=${1}; shift
    local options=${*:-}

    local compose_file="$(compose_file_from_label ${shipping_label})"
    [ -f ${compose_file} ] || fail "Missing docker-compose.yml file in shipping label (${shipping_label})."

    shipping_summary ${shipping_label} ${DRY_RUN} ${options}

    if is_shipping_label_audited ${shipping_label}; then
        run write_version_file_for ${shipping_label} ${compose_file} ${options}
    fi
    local destination="$(destination_from_label ${shipping_label})"

    run pre_deploy_on_host_hooks "${shipping_label}"

    run docker_ready "${destination}"

    run remove_unused_images "${destination}"
    run load_compose_file ${shipping_label} ${options}
    run bring_up_containers ${shipping_label}
    run send_secrets ${shipping_label}

    run post_deploy_on_host_hooks "${shipping_label}"
}

ship "${@}"
