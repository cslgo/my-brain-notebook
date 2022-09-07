KinD Cheat Sheet
===

```shell
## Get help
kind create cluster --help
## Creating a Cluster
kind create cluster --wait 5s
## Delete a Cluster
kind delete cluster
## Creating a Cluster with name
kind create cluster --name wsl-k8s
kind delete cluster --name wsl-k8s
## List clusters
kind get clusters
## 
kubectl cluster-info --context kind-wsl-k8s
```

Loading an Image Into Your Cluster

```shell
## Docker images can be loaded into your cluster nodes with
kind load docker-image my-custom-image-0 my-custom-image-1
## Additionally, image archives can be loaded with
kind load image-archive /my-image-archive.tar
## You can get a list of images present on a cluster node by using 
docker exec -it wsl-k8s-control-plane crictl images
```

This allows a workflow like

```shell
docker build -t my-custom-image:unique-tag ./my-image-dir
kind load docker-image my-custom-image:unique-tag
kubectl apply -f my-manifest-using-my-image:unique-tag
```


Advanced

```shell
## To specify a configuration file when creating a cluster, use the --config flag
kind create cluster --config kind-config.yaml

```

Multi-node clusters

```yaml
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

Control-plane HA

```yaml
# a cluster with 3 control-plane nodes and 3 workers
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: control-plane
- role: control-plane
- role: worker
- role: worker
- role: worker
```

Mapping ports to the host machine

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
    protocol: udp # Optional, defaults to tcp
```

Setting Kubernetes version

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
- role: worker
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
```

Enable Feature Gates in Your Cluster

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
featureGates:
  FeatureGateName: true
```

Configure kind to use a proxy
```
If you are running kind in an environment that requires proxy, you may need to configure kind to use it.

You can configure kind to use a proxy using one or more of thfollowing environment variables (uppercase takes precedence)

  HTTP_PROXY or http_proxy
  HTTPS_PROXY or https_proxy
  NO_PROXY or no_proxy
```
Exporting Cluster Logs

```shell
kind export logs
kind export logs ./somedir
```


