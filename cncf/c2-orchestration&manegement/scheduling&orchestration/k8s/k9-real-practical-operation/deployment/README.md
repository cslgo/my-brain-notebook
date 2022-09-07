Deployment
===

[nginx-deployment.yaml](nginx-deployment.yaml)

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
      app: nginx-pod
  template:         # 设置模板
    metadata:
      labels:
        app: nginx-pod
    spec:
      containers:
      - name: nginx-c
        image: nginx:1.21
```

## 查看

```shell
kubectl apply -f ./nginx-deployment.yaml
#
kubectl get deploy -n samples -o wide
#
kubectl get rs -n samples -o wide
#
kubectl get pods -n samples -o wide
```

## 扩容

```shell
kubectl scale deploy nginx-deployment --replicas=6 -n samples

kubectl edit deploy nginx-deployment  -n samples

```

## 更新策略

重建更新

[nginx-deployment-recreate](nginx-deployment-recreate.yaml)
```yaml
apiVersion: apps/v1
kind: Deployment    # 设置类型
metadata:
  name: nginx-deployment
  namespace: samples
spec:
  strategy:
    type: Recreate  # RollingUpdate
  replicas: 9       # 设置副本数量，修改副本数量实现扩缩容
  selector:
    matchLabels:
      app: nginx-pod
  template:         # 设置模板
    metadata:
      labels:
        app: nginx-pod
    spec:
      containers:
      - name: nginx-c
        image: nginx:1.21
```

```shell
kubectl apply -f nginx-deployment-recreate.yaml
```

滚动更新

[nginx-deployment-rolling-update](nginx-deployment-rolling-update.yaml)
```shell
apiVersion: apps/v1
kind: Deployment    # 设置类型
metadata:
  name: nginx-deployment
  namespace: samples
spec:
  strategy: # 策略
    type: RollingUpdate     # 滚动更新策略
    rollingUpdate:
      maxUnavailable: 25%   # 默认值
      maxSurge: 25%         # 默认值
  replicas: 3       # 设置副本数量，修改副本数量实现扩缩容
  selector:
    matchLabels:
      app: nginx-pod
  template:         # 设置模板
    metadata:
      labels:
        app: nginx-pod
    spec:
      containers:
      - name: nginx-c
        image: nginx:1.21
```


```shell
kubectl apply -f nginx-deployment-rolling-update.yaml
```

## 回滚与更新

`kubectl rollout` 版本升级相关功能，支持以下选项
- status    显示当前升级状态
- history   显示升级历史记录
- pause     暂停版本升级过程
- resume    继续已经暂停的版本升级过程
- restart   重启版本升级过程
- undo      回滚到上以及版本[可以使用 `--to-revision` 回滚到指定版本]

```shell
# 增加升级记录
> kubectl apply -f nginx-deployment-rolling-update.yaml --record=true
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/nginx-deployment configured

# 显示当前升级状态
> kubectl rollout status deploy nginx-deployment -n samples
deployment "nginx-deployment" successfully rolled out

# 显示升级历史记录
> kubectl rollout history deploy nginx-deployment -n samples
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=nginx-deployment-rolling-update.yaml --record=true

# 暂停版本升级过程
> kubectl rollout pause deploy nginx-deployment -n samples
deployment.apps/nginx-deployment paused

# 继续已经暂停的版本升级过程
> kubectl rollout resume deploy nginx-deployment -n samples
deployment.apps/nginx-deployment resumed

# 重启版本升级过程
> kubectl rollout restart deploy nginx-deployment -n samples
deployment.apps/nginx-deployment restarted

# 回滚到上以及版本[可以使用 `--to-revision` 回滚到指定版本]
> kubectl rollout undo deploy nginx-deployment -n samples
deployment.apps/nginx-deployment rolled back
> kubectl rollout history deploy nginx-deployment -n samples
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
2         kubectl apply --filename=nginx-deployment-rolling-update.yaml --record=true
3         kubectl apply --filename=nginx-deployment-rolling-update.yaml --record=true

# 金丝雀发布
# 更新的同时暂停更新，应用场景：测试新的pod，没问题继续更新，有问题直接回滚
> kubectl set image deploy nginx-deployment nginx-c=nginx:latest -n samples && sleep 3 &&  kubectl rollout pause deploy nginx-deployment -n samples

> kubectl get rs -n samples -o wide
NAME                         DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
nginx-deployment-9c7698c96   7         7         7       13h   nginx-c      nginx:1.21     app=nginx-pod,pod-template-hash=9c7698c96
nginx-deployment-9fbdbf477   5         5         0       7s    nginx-c      nginx:latest   app=nginx-pod,pod-template-hash=9fbdbf477

> kubectl set image deploy nginx-deployment nginx-c=nginx:latest -n samples &&  kubectl rollout resume deploy nginx-deployment -n samples

> kubectl get rs -n samples -o wide
NAME                         DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
nginx-deployment-9c7698c96   4         4         4       13h   nginx-c      nginx:1.21     app=nginx-pod,pod-template-hash=9c7698c96
nginx-deployment-9fbdbf477   8         8         3       10s   nginx-c      nginx:latest   app=nginx-pod,pod-template-hash=9fbdbf477

> kubectl get rs -n samples -o wide
NAME                         DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
nginx-deployment-9c7698c96   0         0         0       13h   nginx-c      nginx:1.21     app=nginx-pod,pod-template-hash=9c7698c96
nginx-deployment-9fbdbf477   9         9         9       17s   nginx-c      nginx:latest   app=nginx-pod,pod-template-hash=9fbdbf477

```
