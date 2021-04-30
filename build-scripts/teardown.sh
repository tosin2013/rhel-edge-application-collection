#!/bin/bash
set -x

function removeallpods(){
    array=( strmizi-kafka  strmizi-zookeeper postgresql)
    for i in "${array[@]}"
    do
      podman pod stop $(podman pod ls  | grep $i | awk '{print $2}')
      podman pod rm $(podman pod ls  | grep $i | awk '{print $2}')
    done
}


function removedatagrid(){
    podman stop $(podman ps | grep datagrid-8 | awk '{print $1}')
    podman rm $(podman ps -a  | grep datagrid-8 | awk '{print $1}')
}

function removesinglepod(){
    podman pod stop $(podman pod ls  | grep ${1} | awk '{print $2}')
    podman pod rm $(podman pod ls  | grep ${1} | awk '{print $2}')
}

removeallpods
removedatagrid
rm -rf /data