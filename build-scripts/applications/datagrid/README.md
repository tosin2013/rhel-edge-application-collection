# Red Hat Data Grid
[Red Hat® Data Grid](redhat.com/en/technologies/jboss-middleware/data-grid) is an in-memory, distributed, NoSQL datastore solution. Your applications can access, process, and analyze data at in-memory speed to deliver a superior user experience. 

**Edit source file:**
```
vi build-scripts/applications/datagrid/app_env
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

**Optional: Generate service file and kickstart file**
```
# export GITREPO="https://github.com/username/rhel-edge-automation-arch.git"
# export APPNAME=datagrid-8
# ./build-images/generate-kickstart.sh
```