#!/bin/bash 
#podman run -e GF_INSTALL_PLUGINS="https://github.com/performancecopilot/grafana-pcp/releases/download/vX.Y.Z/performancecopilot-pcp-app-X.Y.Z.zip;performancecopilot-pcp-app" -p ${LISTEN_PORT}:${LISTEN_PORT} grafana/grafana


if [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/pcp/app_env
else
   exit 1
fi 

check-logged-in-user
enable-pcp
login-to-registry

echo "Building grafana container"
${RUN_AS_SUDO} podman pod create --name grafana -p ${LISTEN_PORT}:${LISTEN_PORT} --network rhel-edge  --network slirp4netns:port_handler=slirp4netns


${RUN_AS_SUDO} podman run   \
-d  --pod=grafana  \
-e GF_INSTALL_PLUGINS="https://github.com/performancecopilot/grafana-pcp/releases/download/v3.0.3/performancecopilot-pcp-app-3.0.3.zip;performancecopilot-pcp-app" \
--name=grafana-1  ${CONTAINER_IMAGE}

sudo firewall-cmd --add-port=${LISTEN_PORT}/tcp --zone=public --permanent
sudo firewall-cmd --add-port=${LISTEN_PORT}/tcp --zone=internal --permanent
sudo firewall-cmd --reload

curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${LISTEN_PORT} 

echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${LISTEN_PORT} in browser "
echo "Use http://localhost:44322 as endpoint "
echo "*****************************************************************"

get-pod-status
