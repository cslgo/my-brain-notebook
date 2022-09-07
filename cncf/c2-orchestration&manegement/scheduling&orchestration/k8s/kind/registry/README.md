Local Registry
===
This guide covers how to configure KIND with a local container image registry.

In the future this will be replaced by a built-in feature, and this guide will cover usage instead.

## Create A Cluster And Registry

The following shell script will create a local docker registry and a kind cluster with it enabled.

[local-registry.sh](local-registry.sh)
```shell
#!/bin/sh
set -o errexit

# create registry container unless it already exists
reg_name='kind-registry'
reg_port='5001'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
EOF

# connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
fi

# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
```
## Using The Registry 

The registry can be used like this.

1. First we'll pull an image `docker pull gcr.io/google-samples/hello-app:1.0`
2. Then we'll tag the image to use the local registry `docker tag gcr.io/google-samples/hello-app:1.0 localhost:5001/hello-app:1.0`
3. Then we'll push it to the registry `docker push localhost:5001/hello-app:1.0`
4. And now we can use the image `kubectl create deployment hello-server --image=localhost:5001/hello-app:1.0`

If you build your own image and tag it like `localhost:5001/image:foo` and then use it in kubernetes as `localhost:5001/image:foo`.