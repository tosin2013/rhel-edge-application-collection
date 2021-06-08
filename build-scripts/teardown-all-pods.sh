#!/bin/bash
set -x

ENABLE_PCP="true"
source $(pwd)/build-scripts/applications/functions.sh
enable-pcp

function removeallpods(){
    ${RUN_AS_SUDO} podman pod  stop $(${RUN_AS_SUDO} podman pod ls | grep -v "POD ID" | awk '{print $1}')
    ${RUN_AS_SUDO} podman pod  rm $(${RUN_AS_SUDO} podman pod ls | grep -v "POD ID" | awk '{print $1}')
}

removeallpods