# Build quarkuscoffeeshop-majestic-monolith on singlenode box 

# Requirements

**Tested on**
```
cat /etc/redhat-release
Red Hat Enterprise Linux release 8.6 (Ootpa)
```

**Install the following packages**
```
sudo yum install -y osbuild-composer cockpit-composer lorax
sudo systemctl enable --now osbuild-composer.socket
sudo systemctl enable --now cockpit.socket
sudo yum install composer-cli -y
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

## Push the quarkuscoffeeshop-majestic-monolith.toml to macbhine
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

## TESTING: 
> [kickstart.ks](kickstart.ks)

# Links: 
* https://github.com/osbuild/rhel-for-edge-demo