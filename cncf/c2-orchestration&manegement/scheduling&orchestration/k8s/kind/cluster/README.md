
## 单节点集群

```shell

kind create cluster --config /mnt/d/space/my-brain/notes/k8s/kind/cluster/single.yaml
kubectl cluster-info --context kind-single-cluster
kind delete cluster --name single-cluster
```

## 多节点集群

```shell
kind create cluster --config /mnt/d/space/my-brain/notes/k8s/kind/cluster/multi.yaml
kubectl cluster-info --context kind-multi-cluster
kind delete cluster --name multi-cluster
```


## 高可用部署

```shell
kind create cluster --config /mnt/d/space/my-brain/notes/k8s/kind/cluster/ha.yaml
kubectl cluster-info --context kind-ha-cluster
kind delete cluster --name ha-cluster
```

## delopy

在集群中安装 Dashboard

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml
```

获取 dashboard 的资源对象

```shell
kubectl get all -n kubernetes-dashboard
```
安装成功后，我们可以使用如下命令创建一个临时的代理
```shell
kubectl proxy
```

然后在 Windows 浏览器中我们可以通过如下地址来访问 Dashboard 服务

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


然后我们使用官方推荐的 RBAC 方式来创建一个 Token 进行登录，重新打开一个 WSL2 终端，执行如下所示命令

```shell
## 创建一个新的 ServiceAccount
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF
## 将上面的 SA 绑定到系统的 cluster-admin 这个集群角色上
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

然后接下来我们可以通过上面创建的 ServiceAccount 来获取 Token 信息

```shell
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```