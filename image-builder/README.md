# Build quarkuscoffeeshop-majestic-monolith on singlenode box - WIP

# Requirements

**Tested on**
```
cat /etc/redhat-release
Red Hat Enterprise Linux release 8.6 (Ootpa)
```

**Install the following packages**
```
sudo yum install -y osbuild-composer cockpit-composer lorax skopeo
sudo systemctl enable --now osbuild-composer.socket
sudo systemctl enable --now cockpit.socket
sudo yum install composer-cli -y
```

**Optional: Set up for rootless containers for repo**
```
# sudo yum install slirp4netns podman -y
# sudo tee -a /etc/sysctl.d/userns.conf > /dev/null <<EOT
user.max_user_namespaces=28633
EOT
# sudo sysctl -p /etc/sysctl.d/userns.conf
```

**Access console URL**
* https://Yourip:9090


**clone repo**
```
cd ~
git clone https://github.com/tosin2013/rhel-edge-application-collection.git
cd rhel-edge-application-collection/image-builder
```


## Edit the toml file and update with your own values
> Link: [quarkuscoffeeshop-majestic-monolith.toml](quarkuscoffeeshop-majestic-monolith.toml)
* name = "admin"
* description = "admin"
* replace key = "PUBLIC_KEY" 

## Push the quarkuscoffeeshop-majestic-monolith.toml to machine
```
sudo composer-cli blueprints push  quarkuscoffeeshop-majestic-monolith.toml
```

**review quarkuscoffeeshop-majestic-monolith configuration under Image Builder**
![20220629190623](https://i.imgur.com/AXvXJKg.png)

**Create Image for quarkuscoffeeshop-majestic-monolith**
![20220629202858](https://i.imgur.com/1okh78U.png)
![20220629202929](https://i.imgur.com/6BazIZ2.png)

**Different types off images that can be created**
![20220629203113](https://i.imgur.com/xzb0w7P.png)


**Create Image iso file for via CLI**
```
sudo composer-cli compose start quarkuscoffeeshop-majestic-monolith image-installer
sudo composer-cli compose status
sudo composer-cli compose image image-uuid
```

**Create Image tar file for repo**
```
sudo composer-cli compose types
sudo composer-cli compose start quarkuscoffeeshop-majestic-monolith rhel-edge-container
sudo composer-cli compose status
sudo composer-cli compose image  image-uuid
sudo skopeo copy oci-archive:image-uuid-container.tar containers-storage:localhost/rfe-mirror:image-uuid
sudo podman run -d --restart=always -p 8000:8080 -v $(pwd)/quarkuscoffeeshop-majestic-monolith.ks:/var/www/html/quarkuscoffeeshop-majestic-monolith.ks:Z rfe-mirror:image-uuid

```

**Set firewall for coontainer**
```
sudo firewall-cmd --add-port=8000/tcp --zone=internal --permanent
sudo firewall-cmd --add-port=8000/tcp --zone=public --permanent
sudo firewall-cmd --reload
```

## TESTING: 
> [kickstart.ks](kickstart.ks)
* `cp kickstart.ks quarkuscoffeeshop-majestic-monolith.ks`
* Change 10.0.2.2 to your repo server
* change `yourinfo` with Red Hat login info
* Optional: change podman subnet  `192.168.33.0/24` 
* copy quarkuscoffeeshop-majestic-monolith.ks to your repo server 


**Create iso with custom kickstart**
```
rm quarkuscoffeeshop-majestic-monolith.iso

sudo mkksiso quarkuscoffeeshop-majestic-monolith.ks image-uuid-installer.iso quarkuscoffeeshop-majestic-monolith.iso
```

## For Developers 
> Setup devbox [Setup image builder server](dev-enviornment.md)

**Create VM**
```
.hack/create-kvm-vms.sh quarkuscoffeeshop-majestic-monolith edge-dev
```


**Delete  VM**
```
.hack/delete-kvm-vms.sh quarkuscoffeeshop-majestic-monolith testme-2022
```

# Links: 
* https://github.com/osbuild/rhel-for-edge-demo