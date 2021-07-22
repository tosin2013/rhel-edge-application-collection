#!/bin/bash
set -xe 
CHECKLOGGINGUSER=$(whoami)
if [ ${CHECKLOGGINGUSER} == "root" ];
then 
  echo "login as sudo user to run script."
  echo "You are currently logged in as root"
  exit 1
fi

sudo subscription-manager register

sudo subscription-manager refresh

sudo subscription-manager attach --auto

sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms

sudo dnf module install -y container-tools
sudo yum install git vim curl wget pcp pcp-zeroconf -y

sudo  pip3 install podman-compose

sudo yum install slirp4netns podman -y

sudo tee -a /etc/sysctl.d/userns.conf > /dev/null <<EOT
user.max_user_namespaces=28633
EOT
sudo sysctl -p /etc/sysctl.d/userns.conf

podman network create --driver bridge rhel-edge --subnet 192.168.33.0/24

sudo yum install redis -y
sudo systemctl start redis
sudo systemctl enable redis

sudo systemctl enable  pmlogger_daily_report.timer pmlogger_daily_report-poll.timer --now

sudo systemctl restart pmcd pmlogger 

sudo systemctl enable pmproxy
sudo systemctl start pmproxy
sudo firewall-cmd --add-service=pmproxy --permanent
sudo firewall-cmd --reload