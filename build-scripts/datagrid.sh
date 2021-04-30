#!/bin/bash 

echo "Building DATAGRID container"
DATAGRID_IP=$(cat /etc/hosts | grep datagrid | awk '{print $1}')
podman  run  \
-d  -p 8080:11222 --net rhel-edge  \
--ip ${DATAGRID_IP} -h datagrid \
-e USER="admin" \
-e PASS="password" \
--name datagrid-8 \
registry.redhat.io/datagrid/datagrid-8-rhel8

# datagrid
sudo firewall-cmd --add-port=8080/tcp --zone=internal --permanent
sudo firewall-cmd --add-port=8080/tcp --zone=public --permanent
#sudo firewall-cmd --add-port=11222/tcp --zone=public --permanent
#sudo firewall-cmd --add-port=11222/tcp --zone=internal --permanent
sudo firewall-cmd --reload


