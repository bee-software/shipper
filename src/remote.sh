#!/bin/bash

remote_run_verbose() {
    ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
}

remote_run_script_verbose() {
    ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@" 'bash -es'
}

remote_run() {
    remote_run_verbose "$@" > /dev/null
}

remote_run_script() {
    remote_run_script_verbose "$@" > /dev/null
}

