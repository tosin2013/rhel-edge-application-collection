#!/bin/bash 
set -xe
if [ -z $1 ];
then 
  echo "Please pass user to be created."
  echo "USAGE: $@ username"
  exit 1
fi

USER=${1}

if getent passwd ${USER} > /dev/null 2>&1; then
    echo "${USER} exists"
else
    echo "${USER} does not exist"
    useradd ${USER}
    passwd ${USER}
fi

usermod -aG wheel ${USER}
echo "${USER} ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/${USER}
chmod 0440 /etc/sudoers.d/${USER}