# Build quarkuscoffeeshop-majestic-monolith on singlenode box 

# Requirements

**Tested on**
```
cat /etc/redhat-release
Red Hat Enterprise Linux release 8.5 (Ootpa)
```

**Install the following packages**
```
yum install -y osbuild-composer cockpit-composer
sudo systemctl enable --now osbuild-composer.socket
systemctl enable --now cockpit.socket
yum install composer-cli
```

## Edit the toml file and update with your own values
> Link: [quarkuscoffeeshop-majestic-monolith.toml](quarkuscoffeeshop-majestic-monolith.toml)
* name = "admin"
* description = "admin"
* replace key = "PUBLIC_KEY" 

## Push the quarkuscoffeeshop-majestic-monolith.toml to macbhine
```
 composer-cli blueprints push  quarkuscoffeeshop-majestic-monolith.toml
```

# Links: 
* https://github.com/osbuild/rhel-for-edge-demo