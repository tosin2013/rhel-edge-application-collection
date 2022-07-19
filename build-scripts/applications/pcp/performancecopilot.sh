#!/bin/bash 
#podman run -e GF_INSTALL_PLUGINS="https://github.com/performancecopilot/grafana-pcp/releases/download/vX.Y.Z/performancecopilot-pcp-app-X.Y.Z.zip;performancecopilot-pcp-app" -p ${LISTEN_PORT}:${LISTEN_PORT} grafana/grafana


if [ -f $(pwd)/app_env ] ; 
then
    set -xe 
    source $(pwd)/app_env
    source  $(pwd)/build-scripts/applications/functions.sh
elif [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/pcp/app_env
else
   exit 1
fi 

if [ ${KICK_START} == false ];
then 
    check-logged-in-user
    login-to-registry
    enable-pcp
else
    login-to-registry-auto ${RHEL_USER} ${RHEL_PASSWORD}
fi 



echo "Building grafana container"
${RUN_AS_SUDO} podman pod create --name grafana -p ${LISTEN_PORT}:${LISTEN_PORT} --network rhel-edge 


${RUN_AS_SUDO} podman run   \
-d  --pod=grafana  \
-e GF_INSTALL_PLUGINS="https://github.com/performancecopilot/grafana-pcp/releases/download/v5.0.0/performancecopilot-pcp-app-5.0.0.zip;performancecopilot-pcp-app" \
--name=grafana-1  ${PCP_CONTAINER_IMAGE}

sudo firewall-cmd --add-port=${LISTEN_PORT}/tcp --zone=public --permanent
sudo firewall-cmd --add-port=${LISTEN_PORT}/tcp --zone=internal --permanent
sudo firewall-cmd --reload

curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${LISTEN_PORT} 

echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${LISTEN_PORT} in browser "
echo "Use http://localhost:44322 as endpoint "
echo "*****************************************************************"

get-pod-status
