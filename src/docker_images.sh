#!/bin/bash

list_images() {
    local compose_file=${1}; shift
    local options=${*}

    expand_template ${compose_file} ${options} | grep 'image: ' | awk '{print $2}' | sed 's/"//g'
}

remove_unused_images() {
  local destination="${1}"

  echo "Removing unused images"
  remote_run_script_verbose ${destination} << "__EOF"
    before=$(sudo docker image ls; echo ""; sudo df -h /var/lib/docker)
    sudo docker image rm $(\
      sudo docker images -a --format "{{.Repository}}:{{.Tag}} {{.ID}}" | \
      sed 's/<none>:<none> //g' | cut -d' ' -f1) >/dev/null 2>&1 || true
    after=$(sudo docker image ls; echo ""; sudo df -h /var/lib/docker)
    diff -b -u <(echo "$before") <(echo "$after") || true
__EOF
}
