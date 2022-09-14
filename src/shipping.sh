#!/bin/bash

AUDITED_FILENAME="audited"

destination_from_label() {
    local shipping_label=${1}
    sed 's/#.*//g' ${shipping_label}/destination | grep -v '^$'
}

compose_file_from_label() {
    local shipping_label=${1}
    echo "${shipping_label}/docker-compose.yml"
}

compose_project_name_from_label() {
    local shipping_label=$1

    if [ -f ${shipping_label}/docker_compose_project_name ]; then
        cat ${shipping_label}/docker_compose_project_name
    else
        basename ${shipping_label}
    fi
}

get_shipping_service_name() {
    local dry_run=${1}; shift
    [ ${dry_run} == "1" ] && echo "No delivery (dry run)" || echo "Same day - Next Flight Out"
}

is_shipping_label_audited() {
    local shipping_label=$1
    test -f ${shipping_label}/${AUDITED_FILENAME}
}

shipping_summary() {
    local shipping_label=${1}; shift
    local dry_run=${1}; shift
    local options=${*:-}

    local compose_file="$(compose_file_from_label ${shipping_label})"
    local image_list=$(list_images ${compose_file} ${options})
    local shipping_service=$(get_shipping_service_name ${dry_run})
    local compose_project_name="$(compose_project_name_from_label ${shipping_label})"
    local destination="$(destination_from_label ${shipping_label})"

    cat <<EOF
+-----------------------------------------------------------------------+
| Shipping label
|   ${shipping_label}
+-----------------------------------------------------------------------+
| Shipping service
|   ${shipping_service}
+-----------------------------------------------------------------------+
| To
|   ${destination}
+-----------------------------------------------------------------------+
| Options
|   ${options}
+-----------------------------------------------------------------------+
| Other options:
|   Image namespace: $(config_image_namespace)
|   Image registry URL: $(config_image_registry_url)
+-----------------------------------------------------------------------+
| Audited
|   $(is_shipping_label_audited ${shipping_label} && echo "true" || echo "false")
+-----------------------------------------------------------------------+
| Contents
|   Project name: ${compose_project_name}
|   Images:
$(echo ${image_list} | tr ' ' '\n' | sed 's/^/|     - /')
|   Compose: ${compose_file}
+-----------------------------------------------------------------------+
EOF


}
