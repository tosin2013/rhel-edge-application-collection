#!/bin/bash
set -xe 
CHECKLOGGINGUSER=$(whoami)
if [ ${CHECKLOGGINGUSER} != "root" ];
then 
  echo "login as root user to run script."
  echo "running script as non root is not supported yet"
  echo "please contribte @ githubpage"
  echo "You are currently logged in as $USER"
  exit 1
fi

subscription-manager register

subscription-manager refresh

subscription-manager attach --auto

subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms

dnf module install -y container-tools
yum install git vim curl wget -y

pip3 install podman-compose

yum install slirp4netns podman -y
echo "user.max_user_namespaces=28633" > /etc/sysctl.d/userns.conf
sysctl -p /etc/sysctl.d/userns.conf

sudo podman network create --driver bridge rhel-edge --subnet 192.168.33.0/24
podman network inspect rhel-edge  --format '{{(index  .plugins  0).ipam.ranges}}' >/tmp/podmannetwork
IP=$(cat /tmp/podmannetwork | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
echo $IP
IP_OCTECT=`echo $IP  | cut -d"." -f1-3`
echo $IP_OCTECT

sudo tee -a /etc/hosts > /dev/null <<EOT
${IP_OCTECT}.10 postgresql
${IP_OCTECT}.11 zookeeper
${IP_OCTECT}.12 kafka
${IP_OCTECT}.13 datagrid
EOT
