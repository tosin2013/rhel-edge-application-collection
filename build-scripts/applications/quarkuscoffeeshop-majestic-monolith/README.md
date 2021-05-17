# quarkuscoffeeshop-majestic-monolith
![Quarkus Coffee Shop](https://raw.githubusercontent.com/quarkuscoffeeshop/quarkuscoffeeshop-ansible/master/images/webpage-example.png)
[quarkuscoffeeshop-majestic-monolith](https://github.com/jeremyrdavis/quarkuscoffeeshop-majestic-monolith)  This project uses Quarkus, the Supersonic Subatomic Java Framework. https://quarkuscoffeeshop.github.io/


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
