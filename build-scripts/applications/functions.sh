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
    podman login registry.redhat.io
}