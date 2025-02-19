#!/bin/bash

docker_ready() {
    local host="$1"
    is_docker_installed "$host" || fail "Docker is not installed on $host"
    is_docker_compose_installed "$host"  || fail "Docker-compose is not installed on $host"
}

is_docker_installed() {
    remote_run $1 "docker version"
}

is_docker_compose_installed() {
    remote_run $1 "docker compose version"
}
