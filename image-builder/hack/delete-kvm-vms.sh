#!/bin/bash
set -xe 
if [ $# -ne 2 ]; then
  echo "please pass iso name"
  echo "Usage: $0 <image-name> <vm-name>" 
  exit 1
fi

IMAGE_NAME=${1}
DEV_VM_NAME="${2}-dev"

LIBVIRT_VM_PATH="/var/lib/libvirt/images"
sudo virsh shutdown ${IMAGE_NAME}-${DEV_VM_NAME} || true
sudo virsh undefine ${IMAGE_NAME}-${DEV_VM_NAME} || true
sudo rm -rf  ${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2 
sudo rm -rf ${LIBVIRT_VM_PATH}/${IMAGE_NAME}.iso