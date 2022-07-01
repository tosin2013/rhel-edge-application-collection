# Setup image builder server

**Optional: configure box**
```
sudo su - admin
curl -OL https://gist.githubusercontent.com/tosin2013/ae925297c1a257a1b9ac8157bcc81f31/raw/71a798d427a016bbddcc374f40e9a4e6fd2d3f25/configure-rhel8.x.sh
chmod +x configure-rhel8.x.sh
./configure-rhel8.x.sh
sudo dnf install libvirt -y
```

**Download Qubinode Installer**
```
cd $HOME
git clone https://github.com/tosin2013/qubinode-installer.git
cd ~/qubinode-installer
git checkout rhel-8.6
```

**copy rhel-8.5-update-2-x86_64-kvm.qcow2 to qubinode-installer directory**

**Configure Qubinode box**
```
./qubinode-installer -m setup
./qubinode-installer -m rhsm
./qubinode-installer -m ansible
./qubinode-installer -m host
```