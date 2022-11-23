#!/bin/bash 

if [ -f /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/app_env ] ; 
then
    set -xe 
    source /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/app_env
    source /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/build-scripts/applications/functions.sh
else
   exit 1
fi 

echo "Running First Boot Script" >  /opt/quarkuscoffeeshop-majestic-monolith/first-boot.log
until [ "`podman inspect -f {{.State.Running}} postgresql-1`"=="true" ]; do
    sleep 0.1;
done;

sleep 30s 
echo "Loading database"  | tee -a  /opt/quarkuscoffeeshop-majestic-monolith/first-boot.log
podman exec -i postgresql-1  /bin/bash -c "PGPASSWORD=${DATABASE_PASSWORD} psql --username ${DATABASE_USER} ${DATABASE_NAME} < /data/init-postgresql.sql" | tee -a /tmp/first-boot.log

until [ "`podman inspect -f {{.State.Running}} quarkuscoffeeshop-majestic-monolith-1`"=="true" ]; do
    sleep 0.1;
done;

podman stop quarkuscoffeeshop-majestic-monolith-1  | tee -a  /opt/quarkuscoffeeshop-majestic-monolith/first-boot.log
sleep 30s
echo "Waiting for quarkuscoffeeshop-majestic-monolith-1"  | tee -a  /opt/quarkuscoffeeshop-majestic-monolith/first-boot.log
until [ "`podman inspect -f {{.State.Running}} quarkuscoffeeshop-majestic-monolith-1`"=="true" ]; do
    sleep 0.1;
done;
podman ps  | tee -a  /opt/quarkuscoffeeshop-majestic-monolith/first-boot.log
