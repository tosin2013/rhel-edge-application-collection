# Notes
* Fork [rhel-edge-automation-arch](https://github.com/redhat-cop/rhel-edge-automation-arch) repo
* Create kickstart File
```
# export GITREPO="https://github.com/tosin2013/rhel-edge-automation-arch.git"
# export APPNAME=quarkuscoffeeshop-majestic-monolith 
# ./build-images/generate-kickstart.sh
```



**Get the tekton cli**
```
curl -LO https://github.com/tektoncd/cli/releases/download/v0.17.0/tkn_0.17.0_Linux_x86_64.tar.gz
```
**Extract tkn to your PATH (e.g. /usr/local/bin)**
```
sudo tar xvzf tkn_0.17.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn
```

oc project rfe

cd rhel-edge-automation-arch/

git checkout main 


tkn pipeline start rfe-tarball-pipeline --workspace name=shared-workspace,volumeClaimTemplateFile=openshift/resources/pipelines/volumeclaimtemplate.yaml --use-param-defaults -p blueprints-git-url=https://github.com/tosin2013/rhel-edge-automation-arch.git  -p tooling-git-url=https://github.com/tosin2013/rhel-edge-automation-arch.git -p blueprint-dir=quarkuscoffeeshop-majestic-monolith -s rfe-automation
