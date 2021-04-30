# Edge datagrid
## WIP 
RHEL EDGE DEMO with datagrid first push

![Demo1](images/example-1.gif)
![Demo2](images/example-2.gif)

## To-Do's  
* add ansible scripts build-script and generator
* add script to generate pods 
* add script to generate systemd-unit files
* add Ansible tower for pipeline deployment  to remote sites
* Use  [rhel-edge-automation-arch](https://github.com/redhat-cop/rhel-edge-automation-arch) to build images from current repo


## Initial Steps

### Configure System
**Manual Steps**
* [Manual Steps](configure-system.md)

**Automated Steps** 
```
curl -OL https://raw.githubusercontent.com/tosin2013/rhel-edge-datagrid/main/build-scripts/configure-system.sh
chmod +x configure-system.sh
./configure-system.sh
```

**Clone Git Repo**
```
git clone https://github.com/tosin2013/rhel-edge-datagrid.git
```
**Build Deployment**
```
cd  edge-datagrid
./build-scripts/build.sh 
```

**Teardown Deployment**
```
cd  edge-datagrid
./build-scripts/teardown.sh 
```
**Test deployment**
```
```

**Container for testing**
```
 ./test-container/build-test-container.sh
podman run -it -d  --network rhel-edge fedora /bin/bash 
```

**To access DATAGRID**
![Datagrid](images/datagrid.png)
* from browser hostip:8080
```
$ podman port -l
11222/tcp -> 0.0.0.0:8080

$ curl -I 127.0.0.1:8080
HTTP/1.1 405 Method Not Allowed
content-length: 11
```

## Links: 
* https://www.redhat.com/sysadmin/compose-podman-pods
* [ref-docker-compose](https://stephennimmo.com/ref-docker-compose/)
* https://www.redhat.com/sysadmin/container-networking-podman
* https://developers.redhat.com/blog/2019/01/15/podman-managing-containers-pods/
* https://pcp.io/docs/lab.containers.html
* https://catalog.redhat.com/software/containers/rhel8/pcp/5ede9923bed8bd4f99c6d912takinosh

