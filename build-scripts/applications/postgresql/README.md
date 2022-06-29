# PostgreSQL  
---

[PostgreSQL](https://www.postgresql.org/), also known as Postgres, is a free and open-source relational database management system emphasizing extensibility and SQL compliance. It was originally named POSTGRES, referring to its origins as a successor to the Ingres database developed at the University of California, Berkeley. [Wikipedia](https://en.wikipedia.org/wiki/PostgreSQL)  

**Edit Source file:**
```
vi build-scripts/applications/postgresql/app_env
```

**Change EXTERNAL_ENDPOINT**
*the fqdn or ip  of machine may be used*
```
export EXTERNAL_ENDPOINT="192.168.1.10"   or sed -i "s/192.168.1.10/$(hostname -I | awk '{print $1}')/g"  build-scripts/applications/postgresql/app_env
or 
export EXTERNAL_ENDPOINT="rhel-edge.example.com"
```

### Requirements 
* [Performance Co-Pilot](../../applications/pcp/README.md)  
> To enable podman performance co-pilot add the variable below.
```
export ENABLE_PCP=true
```

**Run build script**
```
 ./build-scripts/applications/postgresql/postgresql.sh 
```

**Optional: Generate service file and kickstart file**
> See Example: [kickstart-example.ks](kickstart-example.ks)
```
# export GITREPO="https://github.com/username/rhel-edge-automation-arch.git"
# export APPNAME=postgresql
# ./build-scripts/generate-kickstart.sh
```