#!/bin/bash 
if [ -d $(pwd)/build-scripts ];
then 
    source  $(pwd)/build-scripts/applications/functions.sh
    source  $(pwd)/build-scripts/applications/quarkuscoffeeshop-majestic-monolith/app_env
else
   exit 1
fi 

check-logged-in-user

echo "Building quarkuscoffeeshop-majestic-monolith container"
podman pod create --name  quarkuscoffeeshop-majestic-monolith  -p ${EXPOSE_PORT}:${EXPOSE_PORT} --network rhel-edge  --network slirp4netns:port_handler=slirp4netns

podman  run -d  \
--pod=quarkuscoffeeshop-majestic-monolith \
-e USER="admin" \
-e PASS="password" \
-e CORS_ORIGINS="http://${EXTERNAL_ENDPOINT}" \
-e STREAM_URL="http://${EXTERNAL_ENDPOINT}\dashboard\stream" \
-e STORE_ID="${STORE_ID}" \
--name quarkuscoffeeshop-majestic-monolith-1 \
${CONTAINER_IMAGE}

# quarkuscoffeeshop-majestic-monolith
sudo firewall-cmd --add-port=${EXPOSE_PORT}/tcp --zone=internal --permanent
sudo firewall-cmd --add-port=${EXPOSE_PORT}/tcp --zone=public --permanent
sudo firewall-cmd --reload

echo "waiting  ${STARTUP_WAIT_TIME}s for pod.."
sleep ${STARTUP_WAIT_TIME}s
curl -vI  --max-time 5.5   http://${EXTERNAL_ENDPOINT}:${EXPOSE_PORT} || exit $?
echo "*****************************************************************"
echo "Open http://${EXTERNAL_ENDPOINT}:${EXPOSE_PORT} in browser"
echo "*****************************************************************"