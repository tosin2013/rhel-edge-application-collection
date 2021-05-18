#!/bin/bash 
# https://developers.redhat.com/blog/2019/05/08/red-hat-enterprise-linux-8-image-builder-building-custom-system-images#
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/composing_a_customized_rhel_system_image/creating-system-images-with-composer-command-line-interface_composing-a-customized-rhel-system-image
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

sudo dnf install -y lorax-composer composer-cli cockpit-composer
sudo firewall-cmd --add-service=cockpit && firewall-cmd --add-service=cockpit --permanent
sudo firewall-cmd --list-services
sudo systemctl enable lorax-composer.socket
sudo systemctl enable cockpit.socket
sudo systemctl start lorax-composer
sudo systemctl start cockpit