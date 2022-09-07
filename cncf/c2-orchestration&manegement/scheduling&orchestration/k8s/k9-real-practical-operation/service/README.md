Service
===

## 创建服务执行部署环境

[service-deployment.yaml](service-deployment.yaml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-deployment
  namespace: samples
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-web
  template:
    metadata:
      labels:
        app: nginx-web
    spec:
      containers:
      - name: nginx-c
        image: nginx:1.21
        lifecycle:   # 启动后执行命令生成一个页面
          postStart:
            exec:
              command: 
              - "/bin/bash"
              - "-c"
              - "echo `date +%F' '%T' '%A ;echo ${RANDOM}${RANDOM} |md5sum` > /usr/share/nginx/html/index.html"
        ports:
        - name: nginx-web-port
          containerPort: 80
          protocol: TCP
```

```shell
> kubectl apply -f ./service-deployment.yaml 
```

## ClusterIp Service

[cluster-ip-service.yaml](cluster-ip-service.yaml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: cluster-ip-service
  namespace: samples
spec:
  sessionAffinity: ClientIP     # 设置亲和性，改变访问规则
  selector:
    app: nginx-web
  clusterIP:               # service 的 ip 地址，如果不写，默认生成一个
  type: ClusterIP
  ports:
  - port: 80            # Service端口
    targetPort: 80      # pod 端口，必须是服务程序运行的端口，否则无法访问
```

```shell
> kubectl apply -f ./cluster-ip-service.yaml

> kubectl describe svc cluster-ip-service -n samples
Name:              cluster-ip-service
Namespace:         samples
Labels:            <none>
Annotations:       <none>
Selector:          app=nginx-web
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.127.203
IPs:               10.96.127.203
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         10.244.3.22:80,10.244.4.26:80,10.244.5.26:80
Session Affinity:  ClientIP
Events:            <none>

> while true;do curl 10.96.127.203:80;sleep 3;done;

```

## HeadLine Service

[head-line-service.yaml](head-line-service.yaml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: head-line-service
  namespace: samples
spec:
  selector:
    app: nginx-web
  clusterIP: None            # 设置为None，创建 headline
  type: ClusterIP
  ports:
  - port: 80            # Service 端口
    targetPort: 80      # pod 端口，必须是服务程序运行的端口，否则无法访问
```

```shell
> kubectl apply -f ./head-line-service.yaml

> kubectl describe svc head-line-service -n samples
```

## NodePort Service

[See](../deployment/hpa/README.md)

## LoadBalancer Service

[load-balancer-servie.yaml](load-balancer-servie.yaml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: load-balnacer-service
  namespace: samples
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  selector:
    app: nginx-web
  type: LoadBalancer   # 服务类型为 LoadBalancer
  externalIPs:  # 配置外部ip地址
    - 10.0.0.16     # service 允许为其分配一个公有IP
```

## ExternalName Service

ExternalName 类型的 Service 用于引入集群外部的服务，它通过 externalName 属性指定外部一个服务的地址，然后在集群内部访问此 service 就可以访问到外部的服务。

[external-name-service.yaml](external-name-service.yaml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-name-service
  namespace: samples
spec:
  selector:
    app: nginx-web
  type:  ExternalName
  externalName: www.baidu.com
```

## Cross Namespace Service

[cross-ns-service/ns-one-service.yaml](cross-ns-service/ns-one-service.yaml)

[cross-ns-service/ns-two-service.yaml](cross-ns-service/ns-two-service.yaml)

```shell
#
> kubectl apply -f cross-ns-service/ns-one-service.yaml
#
> kubectl apply -f cross-ns-service/ns-two-service.yaml
#
> kubectl get deploy -n ns-one -o wide
#
> kubectl get pods -n ns-one -o wide
#
> kubectl get pods -n ns-two -o wide
#
> kubectl get pods -A -o wide  | egrep "ns-one|ns-two"
ns-one               ns-one-dep-6774697d78-4qmfq                         1/1     Running   0               8m52s   10.244.5.27   ha-cluster-worker3          <none>           <none>        
ns-one               ns-one-dep-6774697d78-zqnn4                         1/1     Running   0               8m52s   10.244.3.23   ha-cluster-worker           <none>           <none>        
ns-two               ns-two-dep-6c596f8fd9-8b5cd                         1/1     Running   0               7m50s   10.244.5.28   ha-cluster-worker3          <none>           <none>        
ns-two               ns-two-dep-6c596f8fd9-dc499                         1/1     Running   0               7m50s   10.244.4.27   ha-cluster-worker2          <none>           <none>
#
> kubectl get svc -A -o wide | egrep "ns-one|ns-two"
ns-one        ns-one-service       ClusterIP   10.96.207.169   <none>        80/TCP                   7m10s   app=ns-one-pod,release=v1
ns-two        ns-two-service       ClusterIP   10.96.228.177   <none>        80/TCP                   6m53s   app=ns-two-pod,release=v2
```

```shell
# 进入命名空间下的一个容器
kubectl exec -it  ns-one-dep-6774697d78-4qmfq -n ns-one -- bash
[root@ns-one-dep-6774697d78-4qmfq /]#
[root@ns-one-dep-6774697d78-4qmfq /]# ping -c 4 -W 1  ns-one-service
PING ns-one-service.ns-one.svc.cluster.local (10.96.207.169) 56(84) bytes of data.

--- ns-one-service.ns-one.svc.cluster.local ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3154ms

#
[root@ns-one-dep-6774697d78-4qmfq /]# wget ns-one-service -O ns-one.html

```
[cross-ns-service/cross-ns-service.yaml](cross-ns-service/cross-ns-service.yaml)

```yaml
# 实现 ns-one 名称空间的 pod，访问 ns-two 名称空间的 Service：ns-two-service
apiVersion: v1
kind: Service
metadata:
  name: ns-one-service-external-name
  namespace: ns-one
spec:
  selector:
    app: "ns-one-pod"
    release: "v1"
  type: ExternalName
  externalName: ns-two-service.ns-two.svc.cluster.local
  ports:
  - name: http
    port: 80
    targetPort: 80
---
# 实现 ns-two 名称空间的 pod，访问 ns-one 名称空间的 service：ns-one-service
apiVersion: v1
kind: Service
metadata:
  name: ns-two-service-external-name
  namespace: ns-two
spec:
  selector:
    app: "ns-two-pod"
    release: "v2"
  type: ExternalName
  externalName: ns-one-service.ns-one.svc.cluster.local
  ports:
  - name: http
    port: 80
    targetPort: 80

```

```shell
# 
kubectl exec -it  ns-one-dep-6774697d78-4qmfq -n ns-one -- bash
# 实现跨域名访问
[root@ns-one-dep-6774697d78-4qmfq /]# ping -c 4 -W 1  ns-one-service-external-name

```


