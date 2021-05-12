# RHEL Edge Application collection
> This repo a collection of scripts that will deploy aplications for RHEL edge deployments.

## Tested Against
```
$ podman -v 
podman version 2.2.1

$ cat /etc/redhat-release 
Red Hat Enterprise Linux release 8.3 (Ootpa)
```

## Initial Steps

### Configure System
**Manual Steps**
* [Configure RHEL 8 system](configure-system.md)

**Configure sudo user**
```
curl -OL https://raw.githubusercontent.com/tosin2013/rhel-edge-datagrid/main/build-scripts/setup-sudo-user.sh
chmod +x setup-sudo-user.sh
./setup-sudo-user.sh username
```

**Automated Steps** 
```
curl -OL https://raw.githubusercontent.com/tosin2013/rhel-edge-datagrid/main/build-scripts/configure-system.sh
chmod +x configure-system.sh
./configure-system.sh
```

## To start deploying applications

**Clone Git Repo**
```
git clone https://github.com/tosin2013/rhel-edge-application-collection.git
```

**cd into folder**
```
cd rhel-edge-application-collection
```

## Supported Applications 
### Postgresql and pgadmin4

**Edit Source file:**
```
vi build-scripts/applications/postgresql/app_env
```

**Change EXTERNAL_ENDPOINT**
*the fqdn or ip may be used*
```
export EXTERNAL_ENDPOINT="192.168.1.10"
or 
export EXTERNAL_ENDPOINT="rhel-edge.example.com"
```

**Run build script**
```
 ./build-scripts/applications/postgresql/postgresql.sh 
```

### Datagrid

**Edit source file:**
```
vi build-scripts/applications/postgresql/app_env
```

**Change EXTERNAL_ENDPOINT**
*the fqdn or ip may be used*
```
export EXTERNAL_ENDPOINT="192.168.1.10"
or 
export EXTERNAL_ENDPOINT="rhel-edge.example.com"
```

**Run build script**
```
./build-scripts/applications/datagrid/datagrid.sh 
```

### quarkuscoffeeshop-majestic-monolith

**Edit Source file:**
```
vi build-scripts/applications/quarkuscoffeeshop-majestic-monolith/app_env
```

**Change EXTERNAL_ENDPOINT**
*the fqdn or ip may be used*
```
export EXTERNAL_ENDPOINT="192.168.1.10"
or 
export EXTERNAL_ENDPOINT="rhel-edge.example.com"
```

**Run build script**
```
 ./build-scripts/applications/quarkuscoffeeshop-majestic-monolith/quarkuscoffeeshop-majestic-monolith.sh 
```

**Build Deployment**
```
cd  edge-datagrid
./build-scripts/build.sh 
```

## Teardown all pods
```
cd  edge-datagrid
./build-scripts/teardown-all-pods.sh
```

## Testing container
```
$ ./test-container/build-test-container.sh
podman run -it -d  --network rhel-edge fedora /bin/bash 
```

## Links: 
* https://www.redhat.com/sysadmin/compose-podman-pods
* [ref-docker-compose](https://stephennimmo.com/ref-docker-compose/)
* https://www.redhat.com/sysadmin/container-networking-podman
* https://developers.redhat.com/blog/2019/01/15/podman-managing-containers-pods/
* https://pcp.io/docs/lab.containers.html
* https://catalog.redhat.com/software/containers/rhel8/pcp/5ede9923bed8bd4f99c6d912takinosh

