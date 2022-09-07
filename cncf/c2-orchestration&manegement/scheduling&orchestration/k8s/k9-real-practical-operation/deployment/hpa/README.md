HPA
===
自动扩缩容
---

## 安装插件 [metrics-server](https://github.com/kubernetes-sigs/metrics-server) 


```shell
# 
git clone -b v0.6.1 https://github.com/kubernetes-sigs/metrics-server.git

# or

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# ha
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability.yaml

# helm https://artifacthub.io/packages/helm/metrics-server/metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server

```

## 实操
[nginx-deployment-hpa.yaml](nginx-deployment-hpa.yaml)
```yaml
apiVersion: apps/v1
kind: Deployment    # 设置类型
metadata:
  name: nginx-deployment
  namespace: samples
spec:
  replicas: 3       # 设置副本数量，修改副本数量实现扩缩容
  selector:
    matchLabels:
      run: nginx-pod
  template:         # 设置模板
    metadata:
      labels:
        run: nginx-pod
    spec:
      containers:
      - name: nginx-c
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:   # 必须配置资源限制
          limits:    # 限制最高使用cpu
            cpu: 300m
          requests:  # 限制请求cpu
            cpu: 100m

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: samples
  labels:
    run: nginx-service
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
  selector:
    run: nginx-service
```

```shell
> kubectl apply -f nginx-deployment-hpa.yaml

> kubectl get all -n samples -owide
NAME                                    READY   STATUS    RESTARTS   AGE   IP            NODE                 NOMINATED NODE   READINESS GATES
pod/nginx-deployment-5c99665655-2wmwf   1/1     Running   0          41s   10.244.5.19   ha-cluster-worker3   <none>           <none>
pod/nginx-deployment-5c99665655-lr6zv   1/1     Running   0          41s   10.244.4.19   ha-cluster-worker2   <none>           <none>
pod/nginx-deployment-5c99665655-sqf4n   1/1     Running   0          41s   10.244.3.18   ha-cluster-worker    <none>           <none>

NAME                    TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE     SELECTOR
service/nginx-service   NodePort   10.96.154.77   <none>        80:30980/TCP   2m28s   run=nginx-service

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES       SELECTOR
deployment.apps/nginx-deployment   3/3     3            3           41s   nginx-c      nginx:1.21   run=nginx-pod

NAME                                          DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES       SELECTOR
replicaset.apps/nginx-deployment-5c99665655   3         3         3       41s   nginx-c      nginx:1.21   pod-template-hash=5c99665655,run=nginx-pod

> kubectl expose deploy nginx-deployment --type=NodePort --port=80 -n samples
service/nginx-deployment exposed
```

自动伸缩扩容

[autoscaler.yaml](autoscaler.yaml)
```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-autoscaler
  namespace: samples
spec:
  minReplicas: 3      # 最小pod数量
  maxReplicas: 9      # 最大pod数量
  targetCPUUtilizationPercentage: 3      # cpu 使用率指标
  scaleTargetRef:           #指定要控制的信息
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
```

```shell
#
> kubectl apply -f autoscaler.yaml
#
> kubectl get all -n samples -o wide
#
> kubectl get horizontalpodautoscaler.autoscaling/nginx-autoscaler -n samples -o wide
nginx-autoscaler   Deployment/nginx-deployment   <unknown>/3%   3         9         3          2m30s

```