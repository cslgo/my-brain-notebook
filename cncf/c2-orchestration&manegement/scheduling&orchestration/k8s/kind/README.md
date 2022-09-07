KinD
===

KinD is a tool for running local Kubernetes clusters using Docker container “nodes”.
KinD was primarily designed for testing Kubernetes itself, but may be used for local development or CI.


KinD: Kubernetes in Docker

![](https://d33wubrfki0l68.cloudfront.net/79bdd6c59934dec77bf525514c2416f547407720/a470d/docs/images/diagram.png)

## Installation

### Linux

```shell
# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

KUBECTL=v1.23.4
KIND=v0.12.0

install(){
  wget -O /usr/local/bin/$1 $2
  chmod +x /usr/local/bin/$1
}

# installing kind
install "kind" "https://github.com/kubernetes-sigs/kind/releases/download/${KIND}/kind-linux-amd64"

#installing kubectl
install "kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL}/bin/linux/amd64/kubectl"
```

## Test

```yaml
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
name: test
networking:
  apiServerAddress: "0.0.0.0"

nodes:
# add to the apiServer certSANs the name of the drone service in order to be able to reach the cluster through it
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
      certSANs:
      - "docker"
- role: worker
```

Then 

```
kind create 
```