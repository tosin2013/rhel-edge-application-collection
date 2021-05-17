# RHEL Edge Application collection
> This repo a collection of scripts that will deploy aplications for RHEL edge deployments.

## Tested Against
```
$ podman -v 
podman version 2.2.1
```

## Initial Steps

### Configure System
**Manual Steps**
* [Configure RHEL 8 system](configure-system.md)

**Automated Steps** 
```
curl -OL https://raw.githubusercontent.com/tosin2013/rhel-edge-application-collection/main/build-scripts/configure-system.sh
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
-------
### Postgresql and pgadmin4
[PostgreSQL](build-scripts/applications/postgresql/README.md) is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.


### Datagrid
[Red Hat Data Grid](build-scripts/applications/datagrid/README.md) Red Hat® Data Grid is an in-memory, distributed, NoSQL datastore solution. Your applications can access, process, and analyze data at in-memory speed to deliver a superior user experience.

### quarkuscoffeeshop-majestic-monolith
[ quarkuscoffeeshop-majestic-monolith](build-scripts/applications/quarkuscoffeeshop-majestic-monolith/README.md)


## Testing container**
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
* https://www.redhat.com/en/blog/examining-container-performance-rhel-8-pcp-and-pdma-podman

