#
# Confd Dockerfile
#
# http://github.com/buddho-io/docker-ubuntu-confd

FROM ubuntu:14.04
MAINTAINER lance@buddho.io

ENV DEBIAN_FRONTEND noninteractive

# Update the system
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Confd
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64 -o /usr/local/sbin/confd && \
    chmod 755 /usr/local/sbin/confd

RUN mkdir -p /etc/confd/conf.d

ADD usr/local/sbin/confd-watch.sh /usr/local/sbin/confd-watch

