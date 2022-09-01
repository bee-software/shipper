#!/bin/bash

pre_deploy_on_host_hooks() {
    local shipping_label=$1

    run_hooks $shipping_label pre_deploy on_host
}

post_deploy_on_host_hooks() {
    local shipping_label=$1
    local destination=$(destination_from_label $shipping_label)

    run_hooks $shipping_label post_deploy on_host
}

run_hooks() {
    local shipping_label=$1
    local hook_name=$2
    local type=$3

    local destination=$(destination_from_label $shipping_label)

    if [ -f $shipping_label/hooks/${type}/${hook_name}.sh ]; then
        echo "Running ${hook_name} hooks (${type})" > /dev/stderr
        cat $shipping_label/hooks/${type}/${hook_name}.sh | remote_run_script_verbose ${destination} | sed "s#^#${hook_name}/${type}> #g"
    fi
}