#!/bin/bash

PURPLESHIP_RC="${PURPLESHIP_RC:-$HOME/.purpleshiprc}"

_config() {
  local key=$1
  local default=$2

  local value
  if test -f "${PURPLESHIP_RC}"; then
    value=$(grep "^${key}=" "${PURPLESHIP_RC}" | cut -d'=' -f2)
  fi

  if [ "$value" == "" ]; then
    echo "$default"
  else
    echo "$value"
  fi
}

config_image_namespace() {
  _config "image_namespace" "purpleship"
}

config_image_registry_url() {
  _config "image_registry_url" "registry.purpleship.internal"
}