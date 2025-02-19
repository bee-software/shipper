#!/bin/bash

DOCKER_COMPOSE_PATH="/srv/docker-compose"

load_compose_file() {
  local shipping_label=${1}; shift
  local options=${*}

  local compose_file="$(compose_file_from_label ${shipping_label})"
  local destination="$(destination_from_label ${shipping_label})"

  echo "Loading ${compose_file}"

  local temp=$(mktemp -d /tmp/shipper.XXXXXXXX)
  local folder=$(dirname ${compose_file})
  mkdir -p ${temp}/${folder}
  expand_template $compose_file ${options} > ${temp}/${compose_file}
  for f in $(grep 'env_file: ' $temp/$compose_file | awk '{print $2}' | sed 's/"//g')
  do
    cp ${folder}/${f} ${temp}/${folder}
  done

  chmod -R 'o-rwx' ${temp}

  # NOTE(mmitchell): Ensure the tarball does not contain a '.' entry as this will mess up
  #                  the ownership of /srv/docker-compose itself.
  tar cpf - -C ${temp} ${folder} | remote_run ${destination} "
    sudo mkdir -p ${DOCKER_COMPOSE_PATH}
    sudo chmod 'o-rwx' ${DOCKER_COMPOSE_PATH}
    sudo tar --extract --no-same-owner --file - -C ${DOCKER_COMPOSE_PATH}/"

  rm -rf ${temp}
}

containers_status() {
  local shipping_label=${1}; shift

  local compose_file="$(compose_file_from_label ${shipping_label})"
  local destination="$(destination_from_label ${shipping_label})"
  local project_name="$(compose_project_name_from_label ${shipping_label})"

  remote_run_script_verbose ${destination} << __EOF
    sudo /bin/bash -c "cd ${DOCKER_COMPOSE_PATH} && docker compose \
        --project-name ${project_name} \
        --file ${compose_file} \
        ps ${*}"
__EOF
}

bring_up_containers() {
  local shipping_label=${1}; shift

  local compose_file="$(compose_file_from_label ${shipping_label})"
  local destination="$(destination_from_label ${shipping_label})"
  local project_name="$(compose_project_name_from_label ${shipping_label})"

  echo "Bringing up containers"
  remote_run_script ${destination} << __EOF
    sudo /bin/bash -c "cd ${DOCKER_COMPOSE_PATH} && sudo docker compose \
        --project-name ${project_name} \
        --file ${compose_file} \
        up \
        --remove-orphans \
        -d"
__EOF

  while containers_status "$shipping_label" | grep "\( Exited \| Restarting \| (unhealthy) \| (health: starting) \)"; do
    failed="$(containers_status "$shipping_label" | (grep "\( Exited \| Restarting | (unhealthy) \)" || true) | awk '{ print $1 }')"
    if [ "${failed}" ]; then
      for container in ${failed}; do
        docker logs $container
      done
      fail "Containers are still down :" $failed
    fi
  done
}

container_for_service() {
  local shipping_label=${1}
  local service=${2}

  containers_status ${shipping_label} -q ${service}
}

run_in_container() {
  local shipping_label=${1}; shift
  local service=${1}; shift
  local command=${*}

  local destination="$(destination_from_label ${shipping_label})"

  local container=""
  until [ "${container}" ]
  do
    container=$(container_for_service ${shipping_label} ${service})
  done
  remote_run_verbose ${destination} sudo docker exec -i ${container} ${command}
}
