#!/bin/bash
set -x

function removeallcontainers(){
    podman pod  stop $(podman pod ls | grep -v "POD ID" | awk '{print $1}')
    podman pod  rm $(podman pod ls | grep -v "POD ID" | awk '{print $1}')
}

removeallcontainers