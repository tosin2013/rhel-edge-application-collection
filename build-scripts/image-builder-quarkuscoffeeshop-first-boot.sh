#!/bin/bash 

if [ -f /home/admin/rhel-edge-application-collection/app_env ] ; 
then
    set -xe 
    source /home/admin/rhel-edge-application-collection/app_env
    source  $(pwd)/build-scripts/applications/functions.sh
else
   exit 1
fi 
PODNAME=$(podman ps | grep quarkuscoffeeshop-majestic-monolith-1 | awk '{print $1}')
podman exec -i postgresql-1  /bin/bash -c "PGPASSWORD=${DATABASE_PASSWORD} psql --username ${DATABASE_USER} ${DATABASE_NAME} < /data/init-postgresql.sql"
podman stop ${PODNAME}