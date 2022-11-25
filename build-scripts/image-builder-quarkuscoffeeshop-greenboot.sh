#!/bin/bash 
# Script Location: /etc/greenboot/green.d/image-builder-quarkuscoffeeshop-greenboot.sh
if [ -f /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/app_env ] ; 
then
    set -xe 
    cd /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/
    source /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/app_env
else
   exit 1
fi 


if [ $(  sudo podman ps  -a  | grep  postgresql-1 | wc -l)  -eq 1 ]; then
    ${RUN_AS_SUDO} podman stop postgresql-1 
    ${RUN_AS_SUDO} podman rm postgresql-1 
    ${RUN_AS_SUDO} podman stop pgadmin4-1
    ${RUN_AS_SUDO} podman rm pgadmin4-1
    /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/build-scripts/applications/postgresql/postgresql.sh
    podman exec -i postgresql-1  /bin/bash -c "PGPASSWORD=${DATABASE_PASSWORD} psql --username ${DATABASE_USER} ${DATABASE_NAME} < /data/init-postgresql.sql"
fi 


if [ $(  sudo podman ps  -a  | grep  quarkuscoffeeshop-majestic-monolith-1 | wc -l)  -eq 1 ]; then
    ${RUN_AS_SUDO} podman stop quarkuscoffeeshop-majestic-monolith-1
    ${RUN_AS_SUDO} podman rm quarkuscoffeeshop-majestic-monolith-1
    /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/build-scripts/applications/quarkuscoffeeshop-majestic-monolith/quarkuscoffeeshop-majestic-monolith.sh
fi 


if [ $(  sudo podman ps  -a  | grep  grafana-1 | wc -l)  -eq 1 ]; then
    ${RUN_AS_SUDO} podman stop grafana-1
    ${RUN_AS_SUDO} podman rm grafana-1
    /opt/quarkuscoffeeshop-majestic-monolith/rhel-edge-application-collection/build-scripts/applications/pcp/performancecopilot.sh
fi 