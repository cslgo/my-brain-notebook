#!/bin/sh
set -x
yum remove -y docker-ce containerd
yum autoremove -y
[ -e /etc/docker ] && rm -rf /etc/docker
[ -e /var/lib/docker ] && rm -rf /var/lib/docker
[ -e /etc/containerd ] && rm -rf /etc/containerd
[ -e /var/lib/containerd ] && rm -rf /var/lib/containerd