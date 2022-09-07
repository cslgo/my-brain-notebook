
Kubectl Cheat Sheet
===

- [Kubectl Cheat Sheet](#kubectl-cheat-sheet)
  - [- ](#--)
  - [Node](#node)
  - [Pod](#pod)
  - [Svc](#svc)
  - [Cluster](#cluster)
  - [Operation](#operation)
    - [Create](#create)
    - [Delete](#delete)
    - [Update](#update)
    - [Update](#update-1)
    - [Scale](#scale)
    - [Edit](#edit)
    - [Interaction](#interaction)
    - [Scheduling](#scheduling)
    - [Ohers](#ohers)
  - [](#)
---
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## Node

```shell
## 获取所有 namespace 下面的资源对象
kubectl get all --all-namespaces
##
kubectl describe node ha-cluster-worker
## 
kubectl cluster-info --context kind-ha-cluster
## 检查节点
kubectl get nodes
kubectl get nodes -o wide
## 检查节点
kubectl get nodes -n kube-samples
## 
kubectl get node --show-labels
##
kubectl label nodes <节点名称> labelName=<标签名称>
## 删除节点标签 
kubectl label node <节点名称> labelName=<标签名称>
```
## Pod

```shell
## 查看pod节点 
kubectl get pods -n kube-samples
## 查看pod节点详情
kubectl get pods -o wide -n kube-samples
## 查看所有名称空间下的pod
kubectl get pods --all-namespaces
## 根据yaml文件创建pod 
kubectl apply -f <文件名称>
## 根据yaml文件删除pod
kubectl delete -f <文件名称>
## 删除pod节点
kubectl delete pod <pod名称> -n <名称空间>
## 查看异常的pod节点
kubectl get pods -n <名称空间> | grep -v Running
## 查看异常pod节点的日志
kubectl describe pod <pod名称> -n <名称空间>
```

## Svc

```shell
## 查看服务
kubectl get svc
## 查看服务详情
kubectl get svc -o wide
## 查看所有名称空间下的res：[node,pod,svc,deployment]
kubectl get <res> --all-namespaces

```

## Cluster

```shell
## 查看集群
kubectl get cs
kubectl get pod /svc/deployment -n kube-system

```
## Operation

### Create

```shell
## 创建资源
kubectl create -f ./nginx.yaml
## 创建资源
kubectl apply -f nginx.yaml
## 创建当前目录下的所有yaml资源
kubectl create -f .
## 使用多个文件创建资源
kubectl create -f ./nginx1.yaml -f ./mysql2.yaml
## 使用 url 来创建资源
kubectl create -f https://git.io/vPieo
## 创建带有终端的pod
kubectl run -i --tty busybox --image=busybox 
## 启动一个 nginx 实例
kubectl run nginx --image=nginx
## 启动多个pod
kubectl run mybusybox --image=busybox --replicas=3
## 获取 pod 和 svc 的文档
kubectl explain pods,svc  ?
## 
```

### Delete

```shell
## 根据label删除
kubectl delete pod -l app=flannel -n kube-system
## 删除 pod.json 文件中定义的类型和名称的 pod
kubectl delete -f ./pod.json
kubectl delete -f kubernetes-dashboard.yaml
## 删除名为“baz”的 pod 和名为“foo”的 service
kubectl delete pod,service baz foo 
## 删除具有 name=myLabel 标签的 pod 和 serivce
kubectl delete pods,services -l name=myLabel
## 删除具有name=myLabel 标签的 pod 和 service，包括尚未初始化的
kubectl delete pods,services -l name=myLabel --include-uninitialized 
# 删除 my-ns namespace下的所有 pod 和 serivce，包括尚未初始化的
kubectl delete po,svc --all -n my-ns
## 强制删除
kubectl delete pods prometheus-7fcfcb9f89-qkkf7 --grace-period=0 --force
## 强制替换，删除后重新创建资源。会导致服务中断。
kubectl replace --force -f ./pod.json
```

### Update

```shell
## 滚动更新 pod frontend-v1
kubectl rolling-update python-v1 -f python-v2.json 
## 更新资源名称并更新镜像
kubectl rolling-update python-v1 python-v2 --image=image:v2 
## 更新 frontend pod 中的镜像
kubectl rolling-update python --image=image:v2 
## 退出已存在的进行中的滚动更新
kubectl rolling-update python-v1 python-v2 --rollback 
## pod版本回滚
kubectl rolling-update redis-master --image=redis-master:1.0 --rollback
## 基于 stdin 输入的 JSON 替换 pod
cat pod.json | kubectl replace -f -
## 为 nginx RC 创建服务，启用本地 80 端口连接到容器上的 8000 端口
kubectl expose rc nginx --port=80 --target-port=8000
## 更新单容器 pod 的镜像版本（tag）到 v4
kubectl get pod nginx-pod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -

## 添加注解
kubectl annotate pods nginx-pod icon-url=http://goo.gl/XXBTWq
```


### Update

```shell
## 增加节点lable值
kubectl label nodes node1 zone=north
kubectl label pods nginx-pod new-label=awesome 
## 指定pod在哪个节点
spec.nodeSelector: zone: north
## 增加lable值 key=value
kubectl label pod redis-master-1033017107-q47hh role=master 
## 删除lable值 key=value
kubectl label pod redis-master-1033017107-q47hh role-master
## 修改lable值
kubectl label pod redis-master-1033017107-q47hh role=backend --overwrite
## 增加 taint
kubectl taint node node-1 gpu:yes:NoSchedule
## 删除 taint
kubectl taint node node-1 gpu:NoSchedule-
```

### Scale

```shell
kubectl scale deployment/wordpress --replicas=3 -n kube-samples
kubectl scale replicaset/wordpress-5945c6697c --replicas=3  -n kube-samples
## 将foo副本集变成3个
kubectl scale --replicas=3 rs/foo
## 缩放“foo”中指定的资源
kubectl scale --replicas=3 -f foo.yaml
## 将deployment/mysql从2个变成3个
kubectl scale --current-replicas=2 --replicas=3 deployment/mysql
## 变更多个控制器的数量
kubectl scale --replicas=5 rc/foo rc/bar rc/baz
## 查看变更进度
kubectl rollout status deploy deployment/mysql
## 自动扩展 deployment “foo”
kubectl autoscale deployment foo --min=2 --max=10 
```

### Edit

```shell
## 编辑名为 docker-registry 的 service
kubectl edit svc/docker-registry 
## 使用其它编辑器
KUBE_EDITOR="nano" kubectl edit svc/docker-registry
## 修改启动参数
vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf 
```

### Interaction

```shell
## dump 输出 pod 的日志（stdout）
kubectl logs nginx-pod
## dump 输出 pod 中容器的日志（stdout，pod 中有多个容器的情况下使用）
kubectl logs nginx-pod -c my-container
## 流式输出 pod 的日志（stdout）
kubectl logs -f nginx-pod
## 流式输出 pod 中容器的日志（stdout，pod 中有多个容器的情况下使用）
kubectl logs -f nginx-pod -c my-container
## 交互式 shell 的方式运行 pod
kubectl run -i --tty busybox --image=busybox -- sh
## 连接到运行中的容器
kubectl attach nginx-pod -i
## 转发 pod 中的 6000 端口到本地的 5000 端口
kubectl port-forward nginx-pod 5000:6000
## 在已存在的容器中执行命令（只有一个容器的情况下）
kubectl exec nginx-pod -- ls /
## 在已存在的容器中执行命令（pod 中有多个容器的情况下）
kubectl exec nginx-pod -c my-container -- ls /
## 显示指定 pod 和容器的指标度量
kubectl top pod POD_NAME --containers
## 进入pod
kubectl exec -it podName /bin/bash
```

### Scheduling

```shell
## 标记 my-node 不可调度
kubectl cordon k8s-node
## 清空 my-node 以待维护
kubectl drain k8s-node
## 标记 my-node 可调度
kubectl uncordon k8s-node
## 显示 my-node 的指标度量
kubectl top node k8s-node 
## 将当前集群状态输出到 stdout
kubectl cluster-info dump
## 将当前集群状态输出到 /path/to/cluster-state
kubectl cluster-info dump --output-directory=/path/to/cluster-state
## 如果该键和影响的污点（taint）已存在，则使用指定的值替换
kubectl taint nodes foo dedicated=special-user:NoSchedule

## 导出 proxy
kubectl get ds -n kube-system -l k8s-app=kube-proxy -o yaml > kube-proxy-ds.yaml
## 导出 kube-dns deployment
kubectl get deployment -n kube-system -l k8s-app=kube-dns -o yaml >k ube-dns-dp.yaml
## 导出 kube-dns services
kubectl get services -n kube-system -l k8s-app=kube-dns -o yaml > kube-dns-services.yaml
## 导出所有 configmap
kubectl get configmap -n kube-system -o wide -o yaml > configmap.yaml
## 删除 kube-system 下 Evicted 状态的所有 pod
kubectl get pods -n kube-system | grep Evicted | awk ‘{print $1}’| xargs
```

### Ohers

kubelet

```bash
## 查看kubelet进程启动参数
ps -ef | grep kubelet
## 查看日志:
journalctl -u kubelet -f
## 重启kubelet服务
systemctl daemon-reload
systemctl restart kubelet
## 查看 kubele 全量默认配置
kubeadm config print init-defaults --component-configs KubeletConfiguration
```



api

```shell
## 获取所有api版本信息
kubectl api-versions
## 获取所有api资源信息
kubectl api-resources
```

Start kube-proxy

```shell
kubectl proxy
```

Get token
```shell
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

## 

```bash
sudo kubeadm certs check-expiration
sudo kubeadm certs renew all
```
then copy /etc/kubernetes/admin.conf to your ~/.kube/config

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config  
```

In order for the cluster to actually reload the keys, after you received the following message:

Done renewing certificates. You must restart the kube-apiserver, kube-controller-manager, kube-scheduler and etcd, so that they can use the new certificates.

reload the relevant services with:

```bash
kubectl -n kube-system delete pod -l 'component=kube-apiserver'
kubectl -n kube-system delete pod -l 'component=kube-controller-manager'
kubectl -n kube-system delete pod -l 'component=kube-scheduler'
kubectl -n kube-system delete pod -l 'component=etcd'
```
