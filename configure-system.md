# Configure system for RHEL Edge Application 

**switch to sudo user**

**Register first, then attach a subscription in the Customer Portal**
```
sudo subscription-manager register
```

**Attach a specific subscription through the Customer Portal**
 ```
sudo subscription-manager refresh
```
  
**Attach a subscription from any available that match the system**
```
sudo subscription-manager attach --auto
```

**Register repos for x86**
```
sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
```

**install the container-tools module**
```
sudo dnf module install -y container-tools
sudo yum install git vim -y
```

**Install Performance Co-Pilot**
```
sudo dnf install git vim curl wget pcp pcp-zeroconf -y

sudo systemctl enable  pmlogger_daily_report.timer pmlogger_daily_report-poll.timer --now

systemctl enable pmproxy
systemctl start pmproxy
firewall-cmd --add-service=pmproxy --permanent
firewall-cmd --reload
```

**Install podman compose**
```
sudo pip3 install podman-compose
```

**Set up for rootless containers**
```
# sudo yum install slirp4netns podman -y
# sudo tee -a /etc/sysctl.d/userns.conf > /dev/null <<EOT
user.max_user_namespaces=28633
EOT
# sudo sysctl -p /etc/sysctl.d/userns.conf
```

**Confiure  rhel-edge podman network**
```
# podman network create --driver bridge rhel-edge --subnet 192.168.33.0/24
```