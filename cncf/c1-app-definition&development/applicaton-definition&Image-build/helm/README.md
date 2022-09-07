[Helm](https://helm.sh/) Using
===

The package manager for Kubernetes.

## Installation

### From the Binary Releases

1. Download your [desired version](https://github.com/helm/helm/releases)
2. Unpack it (tar -zxvf helm-v3.0.0-linux-amd64.tar.gz)
3. Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)


```bash
curl https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz -O
tar zxvf helm-v3.9.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
```

## Quick Start Guido

### Initialize a Helm Chart Repository

Once you have Helm ready, you can add a chart repository. Check Artifact Hub for available Helm chart repositories.

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Once this is installed, you will be able to list the charts you can install:

```shell
helm search repo bitnami
```

### Install an Example Chart

To install a chart, you can run the helm install command. Helm has several ways to find and install a chart, but the easiest is to use the bitnami charts.

```shell
helm repo update
helm install bitnami/mysql --generate-name
```

You get a simple idea of the features of this MySQL chart by running

```shell
helm show chart bitnami/mysql
helm show all bitnami/mysql
```

### Learn About Releases

It's easy to see what has been released using Helm:

```shell
helm list
```

Uninstall a Release

```shell
helm uninstall mysql-1612624192
```

If the flag --keep-history is provided, release history will be kept. You will be able to request information about that release:

```shell
helm status mysql-1612624192
```

Because Helm tracks your releases even after you've uninstalled them, you can audit a cluster's history, and even undelete a release (with helm rollback).


## Get help

```shell
helm -h
## helm <commands> -h
helm get -h

```

## 参考
[docs](https://v3.helm.sh/docs/)