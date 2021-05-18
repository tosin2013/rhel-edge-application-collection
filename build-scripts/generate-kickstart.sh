#!/bin/bash 
set -xe

if [[ -z $GITREPO || -z $APPNAME  ]];
then 
  echo "GITREPO or APPNAME is undefined please export those env variables and try again."
  exit 1
fi
  

function cleanup_services(){
    rm -rf /tmp/${APPNAME}.service
    rm -rf ${HOME}/rhel-edge-automation-arch/container-${APPNAME}-1.service 
    rm -rf ${HOME}/rhel-edge-automation-arch/pod-${APPNAME}.service
}

function push_to_git(){
    git pull origin kickstarts
    git add ${1}/kickstart.ks
    git status 
    echo "Enter your commit message"
    read message
    git commit -m"${message}"
    git push 
}

function generate_kickstart(){
    cd ${HOME}
    if [ ! -d ${HOME}/rhel-edge-automation-arch ];
    then 
        git clone $GITREPO
    fi 
    cd rhel-edge-automation-arch
    git checkout kickstarts
    mkdir -p ${APPNAME}
    cp hello-world/kickstart.ks ${APPNAME}/kickstart.ks


cat << EOF >> ${APPNAME}/kickstart.ks

%post

# Set the update policy to automatically download and stage updates to be
# applied at the next reboot
#stage updates as they become available. This is highly recommended
echo AutomaticUpdatePolicy=stage >> /etc/rpm-ostreed.conf

cat > /etc/systemd/system/${APPNAME}.service << 'EOF'
EOF

    podman generate systemd   --new --files --name ${APPNAME}
    cat  ${HOME}/rhel-edge-automation-arch/container-${APPNAME}-1.service | tee -a  ${APPNAME}/kickstart.ks
    echo "" >>${APPNAME}/kickstart.ks
    cat  ${HOME}/rhel-edge-automation-arch/pod-${APPNAME}.service | tee -a  ${APPNAME}/kickstart.ks
    echo "EOF" >> ${APPNAME}/kickstart.ks
    echo ""  >> ${APPNAME}/kickstart.ks

    echo "systemctl enable ${APPNAME}.service"  >> ${APPNAME}/kickstart.ks
    echo ""  >> ${APPNAME}/kickstart.ks
    echo ""  >> ${APPNAME}/kickstart.ks
    echo "%end"  >> ${APPNAME}/kickstart.ks
}



generate_kickstart 
cleanup_services
push_to_git  ${APPNAME}

cd ${HOME}