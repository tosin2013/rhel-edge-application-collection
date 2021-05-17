# Red Hat Data Grid
[Red Hat® Data Grid](redhat.com/en/technologies/jboss-middleware/data-grid) is an in-memory, distributed, NoSQL datastore solution. Your applications can access, process, and analyze data at in-memory speed to deliver a superior user experience. 

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