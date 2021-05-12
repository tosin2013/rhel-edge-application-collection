#!/bin/bash 

VERSION=v1
echo "Building test Container"
cd  test-container
podman build -t test-container:${VERSION} .

podman run -it -d  --network rhel-edge   --network slirp4netns:port_handler=slirp4netns localhost/test-container:${VERSION}   /bin/bash 

EXEC_COMMAND=$(podman ps | grep test-container | awk '{print $1}')

cd ..
echo "To access test Pod"
echo "podman exec -it ${EXEC_COMMAND} /bin/bash"