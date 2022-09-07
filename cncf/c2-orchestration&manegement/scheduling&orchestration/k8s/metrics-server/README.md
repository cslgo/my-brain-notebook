Metrics Server
===

## Kubernetes Resource Status

kubectl top > api-server > metrics-server > kubelet/cadvicer

```bashs
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

`vim components.yaml` 替换镜像源及添加认证参数

```yaml
spec:
  selector:
    matchLabels:
      k8s-app: metrics-server
  strategy:
    rollingUpdate:
      maxUnavailable: 0
  template:
    metadata:
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=4443
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        # 增加参数，跳过安全认证
        - --kubelet-insecure-tls
        - --metric-resolution=15s
        # k8s.gcr.io/metrics-server/metrics-server:v0.6.1
        image: bitnami/metrics-server:0.6.1
```

```bash
kubectl apply -f componets.yamls
```


## Kubelet Status

```bash

$ systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
  Drop-In: /usr/lib/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: active (running) since Tue 2022-05-17 17:57:57 CST; 24h ago
     Docs: https://kubernetes.io/docs/
 Main PID: 49267 (kubelet)
    Tasks: 15
   Memory: 43.7M
   CGroup: /system.slice/kubelet.service
           └─49267 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubele...

May 18 17:57:44 centos-node3 kubelet[49267]: I0518 17:57:44.830900   49267 log.go:195] http: TLS handshake error from 10.10.10.24:49916: remote error: tls...ertificate
May 18 17:57:59 centos-node3 kubelet[49267]: I0518 17:57:59.851379   49267 log.go:195] http: TLS handshake error from 10.10.10.24:49950: remote error: tls...ertificate
May 18 17:58:14 centos-node3 kubelet[49267]: I0518 17:58:14.826224   49267 log.go:195] http: TLS handshake error from 10.10.10.24:49970: remote error: tls...ertificate
May 18 17:58:29 centos-node3 kubelet[49267]: I0518 17:58:29.854880   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50004: remote error: tls...ertificate
May 18 17:58:44 centos-node3 kubelet[49267]: I0518 17:58:44.839744   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50022: remote error: tls...ertificate
May 18 17:58:59 centos-node3 kubelet[49267]: I0518 17:58:59.832871   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50052: remote error: tls...ertificate
May 18 17:59:14 centos-node3 kubelet[49267]: I0518 17:59:14.829713   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50074: remote error: tls...ertificate
May 18 17:59:29 centos-node3 kubelet[49267]: I0518 17:59:29.852825   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50108: remote error: tls...ertificate
May 18 17:59:44 centos-node3 kubelet[49267]: I0518 17:59:44.831966   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50132: remote error: tls...ertificate
May 18 17:59:59 centos-node3 kubelet[49267]: I0518 17:59:59.825961   49267 log.go:195] http: TLS handshake error from 10.10.10.24:50156: remote error: tls...ertificate
Hint: Some lines were ellipsized, use -l to show in full.
```

```bash

$ journalctl -u kubelet -f

$ systemctl restart kubelet

```

## 容器部署

```bash
$ kubectl logs metrics-server-fc59664d9-g4gmh -n kube-system
```

## 系统日志

```
$ sudo tailf /var/log/messages
```

## 查看容器标准输出日志

```bash
$ kubectl logs metrics-server-fc59664d9-g4gmh -n kube-system

$ kubectl logs -f metrics-server-fc59664d9-g4gmh -n kube-system
```

kubectl logs > api-server > kubelet > docker 


```
$ kubectl get pods -n kube-system -o wide | grep metrics
metrics-server-fc59664d9-g4gmh             1/1     Running   0             29m   10.244.204.202   centos-node6   <none>           <none>
# ssh centos-node6
$ sudo crictl ps -a
WARN[0000] runtime connect using default endpoints: [unix:///var/run/dockershim.sock unix:///run/containerd/containerd.sock unix:///run/crio/crio.sock unix:///var/run/cri-dockerd.sock]. As the default settings are now deprecated, you should set the endpoint instead. 
ERRO[0002] connect endpoint 'unix:///var/run/dockershim.sock', make sure you are running as root and the endpoint has been started: context deadline exceeded 
WARN[0002] image connect using default endpoints: [unix:///var/run/dockershim.sock unix:///run/containerd/containerd.sock unix:///run/crio/crio.sock unix:///var/run/cri-dockerd.sock]. As the default settings are now deprecated, you should set the endpoint instead. 
ERRO[0004] connect endpoint 'unix:///var/run/dockershim.sock', make sure you are running as root and the endpoint has been started: context deadline exceeded 
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
a4c310dcaf667       74ec87505f52a       33 minutes ago      Running             metrics-server      0                   c9e2bc3c4bae9
df62a354a1359       a4ca41631cc7a       22 hours ago        Running             coredns             0                   70827830ed855
349deac7fe1c6       77b49675beae1       25 hours ago        Running             kube-proxy          0                   bb3e2f9bed5af
5ffde66432a2a       593794e30dc68       40 hours ago        Running             calico-node         0                   f932a7a090f8b
27156c6dc9330       099ad8a1c45d7       40 hours ago        Exited              install-cni         0                   f932a7a090f8b
26c5ace1019c7       099ad8a1c45d7       40 hours ago        Exited              upgrade-ipam        0                   f932a7a090f8b


```

## 应用日志

```bash
kubectl exec -it pod web-5b99c974f9-sqnpp -n aliang-cka -- bash
```

##  Reference Link

https://github.com/kubernetes-sigs/metrics-server