#!/bin/bash

AUDIT_PATHNAME="audit"

is_managed_image() {
    local image_name=$1
    [[ ${image_name} =~ ^"$(config_image_namespace)" ]]
}

get_image_name() {
    local image_name=$1
    prefix_less=${image_name#"$(config_image_namespace)/"}
    suffix_less=${prefix_less%:*}
    echo ${suffix_less}
}

get_project_version() {
    local image_name=$1
    echo ${image_name} | cut -f2 -d":"
}

append_version_to_file() {
    local shipping_label=$1
    local image_name=$2
    local version=$3
    local destination="$(destination_from_label ${shipping_label})"

    path=$(dirname $0)/../../${AUDIT_PATHNAME}
    echo -e "$(date +%s)\t${destination}\t${version}" >> ${path}/${image_name}
}

write_version_file_for() {
    local shipping_label=${1}; shift
    local compose_file=${1}; shift
    local options=${*:-}

    images=$(list_images ${compose_file} ${options} | strip_registry_url "$(config_image_registry_url)")

    for image in $images; do
        if is_managed_image ${image}; then
            image_name=$(get_image_name ${image})
            version=$(get_project_version ${image})
            append_version_to_file ${shipping_label} ${image_name} ${version}
        fi
    done
}

strip_registry_url() {
    url=$1

    sed "s#^$url/##g"
}

get_current_product_version() {
    cat "$(dirname $0)/../../product-version/navigateur"
}

get_major() {
  local version=$1
  echo ${version} | cut -f 1 -d '.'
}

get_minor() {
  local version=$1
  echo ${version} | cut -f 2 -d '.'
}

increment() {
  local minor=$1
  minor=$(echo ${minor} | sed 's/^0*//g')
  let "minor+=1"
  printf "%02d\n" ${minor}
}
