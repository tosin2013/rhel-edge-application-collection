#!/bin/bash 

if [ -f /home/admin/rhel-edge-application-collection/app_env ] ; 
then
    set -xe 
    source /home/admin/rhel-edge-application-collection/app_env
    source /home/admin/rhel-edge-application-collection/build-scripts/applications/functions.sh
else
   exit 1
fi 

echo "Running First Boot Script" > /tmp/first-boot.log
PODNAME=$(podman ps | grep quarkuscoffeeshop-majestic-monolith-1 | awk '{print $1}') | tee -a /tmp/first-boot.log
podman exec -i postgresql-1  /bin/bash -c "PGPASSWORD=${DATABASE_PASSWORD} psql --username ${DATABASE_USER} ${DATABASE_NAME} < /data/init-postgresql.sql" | tee -a /tmp/first-boot.log
podman stop ${PODNAME}  | tee -a /tmp/first-boot.log
podman ps  | tee -a /tmp/first-boot.log