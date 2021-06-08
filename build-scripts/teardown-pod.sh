#!/bin/bash 
set -xe
if [ -z $1 ];
then 
  echo "Please pass pod name"
  echo "USAGE: $0 quarkuscoffeeshop-majestic-monolith"
  exit $? 
fi 

APP_NAME=${1}
ENABLE_PCP="true"
source $(pwd)/build-scripts/applications/functions.sh

enable-pcp

${RUN_AS_SUDO} systemctl stop  ${APP_NAME}
CONTAINER_ID=$(${RUN_AS_SUDO} podman pod ls | grep   ${APP_NAME} | awk '{print $1}')
${RUN_AS_SUDO} podman pod stop ${CONTAINER_ID}
${RUN_AS_SUDO} podman pod rm ${CONTAINER_ID}
${RUN_AS_SUDO} rm  /etc/systemd/system/${APP_NAME}.service 
