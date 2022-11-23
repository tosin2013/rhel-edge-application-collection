#!/bin/bash
#set -xe 

if [ -f $(pwd)/app_env ] ; 
then
    set -xe 
    source $(pwd)/app_env
    source  $(pwd)/build-scripts/applications/functions.sh
elif [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/postgresql/app_env
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

echo "Building POSTGRESQL_DATABASE container"
# ${RUN_AS_SUDO} podman pod create --name postgresql -p 5432:5432 --network rhel-edge

mkdir -p ${WORKING_DIR}
curl -L https://raw.githubusercontent.com/jeremyrdavis/quarkuscoffeeshop-majestic-monolith/main/init-postgresql.sql  --output /tmp/init-postgresql.sql
cp /tmp/init-postgresql.sql ${WORKING_DIR}/init-postgresql.sql

#--pod=postgresql

${RUN_AS_SUDO} podman run   \
-d --restart=always  --network=host -v ${WORKING_DIR}:/data:Z \
-e POSTGRESQL_DATABASE="${DATABASE_NAME}" \
-e POSTGRESQL_USER="${DATABASE_USER}" \
-e POSTGRESQL_PASSWORD="${DATABASE_PASSWORD}" \
--name=postgresql-1 registry.redhat.io/rhel8/postgresql-13 

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
if [ ${KICK_START} == false ];
then 
    ${RUN_AS_SUDO}  podman exec -i postgresql-1  /bin/bash -c "PGPASSWORD=${DATABASE_PASSWORD} psql --username ${DATABASE_USER} ${DATABASE_NAME} < /data/init-postgresql.sql"
fi 

${RUN_AS_SUDO} firewall-cmd --add-port=5432/tcp --zone=public --permanent
${RUN_AS_SUDO} firewall-cmd --add-port=5432/tcp --zone=internal --permanent
${RUN_AS_SUDO} firewall-cmd --reload

echo "*****************************************************************"
echo "POSTGRESS EXTERNAL ENDPOINT ${EXTERNAL_ENDPOINT}:5432"
echo "*****************************************************************"

echo "Building pgadmin4 container"
#${RUN_AS_SUDO}  podman pod create --name pgadmin4 -p ${PGADMIN_LISTEN_PORT}:${PGADMIN_LISTEN_PORT} --network rhel-edge

${RUN_AS_SUDO}  podman run   \
-d --restart=always --network=host \
-e PGADMIN_DEFAULT_EMAIL="${PGADMIN_DEFAULT_EMAIL}" \
-e PGADMIN_DEFAULT_PASSWORD="${PGADMIN_DEFAULT_PASSWORD}" \
-e PGADMIN_LISTEN_PORT="${PGADMIN_LISTEN_PORT}" \
--name=pgadmin4-1 docker.io/dpage/pgadmin4:latest

${RUN_AS_SUDO} firewall-cmd --add-port=${PGADMIN_LISTEN_PORT}/tcp --zone=public --permanent
${RUN_AS_SUDO} firewall-cmd --add-port=${PGADMIN_LISTEN_PORT}/tcp --zone=internal --permanent
${RUN_AS_SUDO} firewall-cmd --reload

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${PGADMIN_LISTEN_PORT} 

echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${PGADMIN_LISTEN_PORT} in browser"
echo "*****************************************************************"

get-pod-status
