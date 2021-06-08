#!/bin/bash 
if [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/quarkuscoffeeshop-majestic-monolith/app_env
else
   exit 1
fi 



check-logged-in-user
enable-pcp
auto-updatecontainer

echo "Building quarkuscoffeeshop-majestic-monolith container"
${RUN_AS_SUDO} podman pod create --name  quarkuscoffeeshop-majestic-monolith  -p ${EXPOSE_PORT}:${EXPOSE_PORT} --network rhel-edge  --network slirp4netns:port_handler=slirp4netns

${RUN_AS_SUDO} podman  run -d  \
--pod=quarkuscoffeeshop-majestic-monolith \
 ${AUTO_UPDATE} \
-e PGSQL_URL=${PGSQL_URL} \
-e PGSQL_USER=${PGSQL_USER} \
-e PGSQL_PASSWORD=${PGSQL_PASSWORD} \
-e PGSQL_URL_BARISTA=${PGSQL_URL_BARISTA} \
-e PGSQL_USER_BARISTA=${PGSQL_USER_BARISTA} \
-e PGSQL_PASSWORD_BARISTA=${PGSQL_PASSWORD_BARISTA} \
-e PGSQL_URL_KITCHEN=${PGSQL_URL_KITCHEN} \
-e PGSQL_USER_KITCHEN=${PGSQL_USER_KITCHEN} \
-e PGSQL_PASSWORD_KITCHEN=${PGSQL_PASSWORD_KITCHEN} \
-e CORS_ORIGINS="http://${EXTERNAL_ENDPOINT}" \
-e STREAM_URL="http://${EXTERNAL_ENDPOINT}:8080/dashboard/stream" \
-e STORE_ID="${STORE_ID}" \
--name quarkuscoffeeshop-majestic-monolith-1 \
${CONTAINER_IMAGE}:${CONTAINER_TAG}

# quarkuscoffeeshop-majestic-monolith
sudo firewall-cmd --add-port=${EXPOSE_PORT}/tcp --zone=internal --permanent
sudo firewall-cmd --add-port=${EXPOSE_PORT}/tcp --zone=public --permanent
sudo firewall-cmd --reload

if [ ${AUTOUPDATE_CONTAINER} == "true" ];
then
    ${RUN_AS_SUDO} podman generate systemd --new  quarkuscoffeeshop-majestic-monolith-1 > quarkuscoffeeshop-majestic-monolith.service
    ${RUN_AS_SUDO} cp quarkuscoffeeshop-majestic-monolith.service  /etc/systemd/system/
    ${RUN_AS_SUDO} systemctl daemon-reload
    ${RUN_AS_SUDO} systemctl start quarkuscoffeeshop-majestic-monolith
fi

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${EXPOSE_PORT} || exit $?
echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${EXPOSE_PORT} in browser"
echo "*****************************************************************"

get-pod-status