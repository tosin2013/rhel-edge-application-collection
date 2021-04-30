
# A basic apache server. To use either add or bind mount content under /var/www
FROM  fedora:latest

MAINTAINER Tosin Akinosho:0.1

RUN dnf update -y && dnf install -y \
    iputils \
    bind-utils \
    jq \
    vim 

CMD ["/usr/bin"]