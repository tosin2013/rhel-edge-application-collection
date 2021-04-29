# Configure system for datagrid

**Register first, then attach a subscription in the Customer Portal**
```
subscription-manager register
```

**Attach a specific subscription through the Customer Portal**
 ```
subscription-manager refresh
```
  
**Attach a subscription from any available that match the system**
```
subscription-manager attach --auto
```

**Register repos for x86**
```
subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
```

**install the container-tools module**
```
dnf module install -y container-tools
yum install git vim -y
```

**Install podman compose**
```
pip3 install podman-compose
```


**Set up for rootless containers**
```
# yum install slirp4netns podman -y
# echo "user.max_user_namespaces=28633" > /etc/sysctl.d/userns.conf
# sysctl -p /etc/sysctl.d/userns.conf
```