#!/bin/bash 

function check-logged-in-user(){
    CHECKLOGGINGUSER=$(whoami)
    if [ ${CHECKLOGGINGUSER} == "root" ];
    then 
    echo "login as sudo user to run script."
    echo "You are currently logged in as root"
    exit 1
    fi
}


function login-to-registry(){
    echo "logging in to registry.redhat.io"
    ${RUN_AS_SUDO} podman login registry.redhat.io
}

function login-to-registry-auto(){
    echo "logging in to registry.redhat.io"
    ${RUN_AS_SUDO} podman login  -u ${1} -p ${2} registry.redhat.io
}


function enable-pcp(){
    if [ ${ENABLE_PCP} == "true" ];
    then
        RUN_AS_SUDO="sudo"
    fi
}

function auto-updatecontainer(){
    if [ ${AUTOUPDATE_CONTAINER} == "true" ];
    then
        AUTO_UPDATE='--label "io.containers.autoupdate=image"'
    fi
}


function get-pod-status(){
    echo "*****************************************************************"
    echo "to check status of pods and containers run the following commands"
    echo "${RUN_AS_SUDO} podman pod ls ::::  ${RUN_AS_SUDO}  podman ps     "
    echo "*****************************************************************"
}