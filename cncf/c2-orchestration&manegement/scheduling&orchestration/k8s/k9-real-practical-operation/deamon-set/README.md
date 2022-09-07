Daemon Set
===
守护进程
---

每个 Pod 都会初始化一个该售后进程

## 实操

[nginx-daemon-set.yaml](./nginx-daemon-set.yaml)

```yaml
apiVersion: apps/v1
kind: DaemonSet    # 设置类型
metadata:
  name: nginx-daemon-set
  namespace: samples
spec:
  selector:
    matchLabels:
      run: nginx-d
  template:         # 设置模板
    metadata:
      labels:
        run: nginx-d
    spec:
      containers:
      - name: nginx-dc
        image: nginx:1.21

```

```shell
> kubectl apply -f ./nginx-daemon-set.yaml

> kubectl get pods -n samples -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP            NODE                 NOMINATED NODE   READINESS GATES
nginx-deployment-5c99665655-2wmwf   1/1     Running   0          46m   10.244.5.19   ha-cluster-worker3   <none>           <none>
nginx-deployment-5c99665655-lr6zv   1/1     Running   0          46m   10.244.4.19   ha-cluster-worker2   <none>           <none>
nginx-deployment-5c99665655-sqf4n   1/1     Running   0          46m   10.244.3.18   ha-cluster-worker    <none>           <none>
nginx-ds-5sjnk                      1/1     Running   0          22s   10.244.4.21   ha-cluster-worker2   <none>           <none>
nginx-ds-6zh5q                      1/1     Running   0          22s   10.244.5.21   ha-cluster-worker3   <none>           <none>
nginx-ds-z9xpl                      1/1     Running   0          22s   10.244.3.20   ha-cluster-worker    <none>           <none>

> kubectl get ds -n samples -o wide

> kubectl delete -f ./nginx-daemon-set.yaml
```
