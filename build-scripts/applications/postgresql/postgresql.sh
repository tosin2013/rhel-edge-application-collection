#!/bin/bash
set -xe 
if [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/postgresql/app_env
else
   exit 1
fi 

check-logged-in-user
login-to-registry


echo "Building POSTGRESQL_DATABASE container"
podman pod create --name postgresql -p 5432:5432 --network rhel-edge  --network slirp4netns:port_handler=slirp4netns

sudo mkdir -p /pgadmin4
podman run   \
-d --restart=always --pod=postgresql \
-v /pgadmin4:/pgadmin4 \
-e POSTGRESQL_DATABASE="${DATABASE_NAME}" \
-e POSTGRESQL_USER="${DATABASE_USER}" \
-e POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}" \
--name=postgresql-1 registry.redhat.io/rhel8/postgresql-12 

sudo firewall-cmd --add-port=5432/tcp --zone=public --permanent
sudo firewall-cmd --add-port=5432/tcp --zone=internal --permanent
sudo firewall-cmd --reload

echo "*****************************************************************"
echo "POSTGRESS EXTERNAL ENDPOINT ${EXTERNAL_ENDPOINT}:5432"
echo "*****************************************************************"

echo "Building pgadmin4 container"
podman pod create --name pgadmin4 -p ${PGADMIN_LISTEN_PORT}:${PGADMIN_LISTEN_PORT} --network rhel-edge  --network slirp4netns:port_handler=slirp4netns

sudo mkdir -p /pgadmin4
podman run   \
-d --restart=always --pod=pgadmin4 \
-e PGADMIN_DEFAULT_EMAIL="${PGADMIN_DEFAULT_EMAIL}" \
-e PGADMIN_DEFAULT_PASSWORD="${PGADMIN_DEFAULT_PASSWORD}" \
-e PGADMIN_LISTEN_PORT="${PGADMIN_LISTEN_PORT}" \
--name=pgadmin4-1 dpage/pgadmin4:latest

sudo firewall-cmd --add-port=${PGADMIN_LISTEN_PORT}/tcp --zone=public --permanent
sudo firewall-cmd --add-port=${PGADMIN_LISTEN_PORT}/tcp --zone=internal --permanent
sudo firewall-cmd --reload

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${PGADMIN_LISTEN_PORT} 

echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${PGADMIN_LISTEN_PORT} in browser"
echo "*****************************************************************"