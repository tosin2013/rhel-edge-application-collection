#!/bin/bash 
#set -xe 
if [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/datagrid/app_env
else
   exit 1
fi 

check-logged-in-user
login-to-registry


echo "Building DATAGRID container"
# This does not work in a pod
#podman pod create --name datagrid -p 11222:11222 --network rhel-edge  --network slirp4netns:port_handler=slirp4netns

#podman  run  \
#-d  \
#--pod=datagrid \
#-e USER="${USER_NAME}" \
#-e PASS="${PASSWORD}" \
#--name datagrid-8 \
#${CONTAINER_IMAGE}

podman  run  \
-d  -p 11222:11222 --net rhel-edge  --network slirp4netns:port_handler=slirp4netns  \
-h datagrid \
-e USER="${USER_NAME}" \
-e PASS="${PASSWORD}" \
--name datagrid-8 \
${CONTAINER_IMAGE}

# datagrid
sudo firewall-cmd --add-port=11222/tcp --zone=public --permanent
sudo firewall-cmd --add-port=11222/tcp --zone=internal --permanent
sudo firewall-cmd --reload

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:11222 

echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:11222 in browser"
echo "*****************************************************************"

get-pod-status