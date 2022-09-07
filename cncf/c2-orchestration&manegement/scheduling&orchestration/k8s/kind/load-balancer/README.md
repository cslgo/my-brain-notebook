LoadBalancer
===
This guide covers how to get service of type LoadBalancer working in a kind cluster using Metallb.

This guide complements metallb installation docs, and sets up metallb using layer2 protocol. For other protocols check metallb configuration docs.

With Docker on Linux, you can send traffic directly to the loadbalancer's external IP if the IP space is within the docker IP space.

On macOS and Windows, docker does not expose the docker network to the host. Because of this limitation, containers (including kind nodes) are only reachable from the host via port-forwards, however other containers/pods can reach other things running in docker including loadbalancers. You may want to check out the Ingress Guide as a cross-platform workaround. You can also expose pods and services using extra port mappings as shown in the extra port mappings section of the Configuration Guide.

## Installing metallb using default manifests

If you’re using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode.

You can achieve this by editing kube-proxy config in current cluster:

```shell
kubectl edit configmap -n kube-system kube-proxy
```

and edit

```yaml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```

You can also add this configuration snippet to your kubeadm-config, just append it with --- after the main configuration.

If you are trying to automate this change, these shell snippets may help you:

```shell
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

```

Create the metallb namespace 
```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
```
Or
```shell
cat <EOF | kubectl create -f -
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
  labels:
    app: metallb
EOF
```

Apply metallb manifest 

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
```

Wait for metallb pods to have a status of Running
```shell
kubectl get pods -n metallb-system --watch
```

The installation manifest does not include a configuration file. MetalLB’s components will still start, but will remain idle until you define and deploy a [configmap](https://metallb.universe.tf/configuration/).

## Setup address pool used by loadbalancers 

To complete layer2 configuration, we need to provide metallb a range of IP addresses it controls. We want this range to be on the docker kind network.

```shell
> docker network inspect -f '{{.IPAM.Config}}' kind
[{172.19.0.0/16  172.19.0.1 map[]} {fc00:f853:ccd:e793::/64  fc00:f853:ccd:e793::1 map[]}]
```
The output will contain a cidr such as 172.19.0.0/16. We want our loadbalancer IP range to come from this subclass. We can configure metallb, for instance, to use 172.19.255.200 to 172.19.255.250 by creating the configmap.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.19.255.200-172.19.255.250
```
[Apply the contents](layer-2-config.yaml)

```
kubectl apply -f ./layer-2-config.yaml
```

## Using LoadBalancer

The following example creates a loadbalancer service that routes to two http-echo pods, one that outputs foo and the other outputs bar.

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: lb1-app
  labels:
    app: http-echo
spec:
  containers:
  - name: lb1-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=foo"
---
kind: Pod
apiVersion: v1
metadata:
  name: lb2-app
  labels:
    app: http-echo
spec:
  containers:
  - name: lb2-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=bar"
---
kind: Service
apiVersion: v1
metadata:
  name: lb-service
spec:
  type: LoadBalancer
  selector:
    app: http-echo
  ports:
  # Default port used by the image
  - port: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: lb-ingress
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: "/lb"
        backend:
          service:
            name: lb-service
            port:
              number: 5678
```

Intall ingress-nginx

```
kubectl apply -f ../ingress/nginx/ingress-nginx-1.1.3.yaml
```

Apply the contents

```shell
kubectl apply -f ./lb-usage.yaml
```

Now verify that the loadbalancer works by sending traffic to it's external IP and port.

```shell
❯ kubectl get svc/lb-service
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)          AGE
lb-service   LoadBalancer   10.108.135.2   172.19.255.201   5678:32510/TCP   7m58s
❯ LB_IP=$(kubectl get svc/lb-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

In node internal 
```shell
# should output foo and bar on separate lines 
for _ in {1..10}; do
  curl ${LB_IP}:5678
done  
```

With ingress nginx
```
curl localhost/lb
```