#!/bin/bash

GLOBAL_SHIPPER_RC="${SHIPPER_RC:-$HOME/.shipperrc}"
LOCAL_SHIPPER_RC=".shipperrc"

_config() {
  local key=$1
  local default=$2

  local value
  if test -f "${LOCAL_SHIPPER_RC}"; then
    value=$(grep "^${key}=" "${LOCAL_SHIPPER_RC}" | cut -d'=' -f2)
  fi

  if [ "$value" == "" ] && test -f "${GLOBAL_SHIPPER_RC}"; then
    value=$(grep "^${key}=" "${GLOBAL_SHIPPER_RC}" | cut -d'=' -f2)
  fi

  if [ "$value" == "" ]; then
    echo "$default"
  else
    echo "$value"
  fi
}

config_image_namespace() {
  _config "image_namespace" "shipper"
}

config_image_registry_url() {
  _config "image_registry_url" "registry.shipper.internal"
}