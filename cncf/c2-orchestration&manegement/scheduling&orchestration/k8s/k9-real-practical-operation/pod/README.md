Pod
===

## Pod 详解

```shell
## Pause容器是每个pod容器的根容器  判断pod健康状态，实现pod内部网路通信

##  列出资源一级属性
kubectl explain pod
##  列出资源二级属性
kubectl explain pod.spec

## 获取所有api版本信息
kubectl api-versions
## 获取所有api资源信息
kubectl api-resources

```

## 镜像拉取策略

```yaml
spec:             # 规格配置
  containers:
    imagePullPolicy: IfNotPresent   # 镜像拉取策略有三种：Always IfNotPresent Never
# 如果镜像 tag 是具体版本，默认策略是 IfNotPresent
# 如果镜像 tag 是 latest，默认策略是 always
```

## 增加环境变量与启动命令

```yaml
spec:             # 规格配置
  containers:
  - name: nginx-c       # 容器名称
    image: nginx:1.21  # 镜像名称
    imagePullPolicy: IfNotPresent
  - name: centos-c
      image: centos:7.9.2009
      imagePullPolicy: IfNotPresent
      command: [ "/bin/bash", "-ce", "tail -f /dev/null" ]      # 防止容器自动退出
      env:     # 设置环境变量列表
      - name: "username"
        value: "admin"
      - name: "password"
        value: "123456"
```

## 增加端口设置

```yaml
spec:
  containers:
    ports:      #  设置容器暴露端口列表  ports<[]obect>
    - name: port-c         # 容器端口名称，如果指定必须保证name在pod中唯一性
      containerPort: 80      # 容器要监听的端口
      protocol: TCP          # 端口协议，必须是UDP，TCP，或者SCTP。默认TCP
      # hostPort:            # 一般省略，设置会独占宿主机某个端口
      # hostIP:              # 一般省略,要将外部端口绑定到的主机ip
```

## 增加容器资源限制

```yaml
spec:
  containers:
    resources:          #  资源配额限制
      limits:           #  资源-上限，如果超过容器将停止并重启
        cpu: "2"        #  CPU限制，单位是core数
        memory: "10Gi"  #  内存限制
      requests:         #  请求资源-下限，如果资源不够，无法启动容器
        cpu: "1"        #  CPU限制，单位是core数
        memory: "6Gi"   #  内存限制
```

## 生命周期

```yaml
# 5种状态:   
#   挂起 pending 
#   运行 running 
#   成功 succeded 
#   失败 failed 
#   未知 unknown

#  钩子函数  
#  kubectl explain pod.spec.containers.lifecycle
#  kubectl explain pod.spec.containers.lifecycle.postStart
#  kubectl explain pod.spec.containers.lifecycle.postStart.exec
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    lifecycle:
      postStart:
        exec:    # 在容器启动时，执行一个命令  列表写法1
          command: ["/bin/bash","-c","echo 'postStart....hello nginx' > /usr/share/nginx/html/index.html"]
      preStop:   # 在容器终止时，停止nginx服务
        exec:
          command:  # 列表的写法2 [推荐写成yaml列表式]# 等同于command: ["/bin/bash","-s","quit"]
          - "/bin/bash"
          - "-s"
          - "quit"
```

```shell
kubectl expose pod  pod-port --type=NodePort --port=80 --target-port=80 -n devlop

kubectl get pods pod-port -n devlop -o wide

kubectl get svc -n devlop 
```

## 探针

存活性探针  liveness probes     检查容器是否正常运行，如果不是，则k8s重启容器

就绪性探针  readness probes     检查容器是否可以接收请求，如果不是，k8s不会转发流量

livenessProbe 决定是否重启容器 readnessProbe 决定是否转发流量给容器

```yaml
spec:
  containers:
    livenessProbe:
      exec:
        command:
        - "/bin/cat"
        - "/tmp/hello.txt"    # 执行一个查看文件的命令  
```

```yaml
spec:
  containers:
    livenessProbe:
      tcpSocket:
        port: 8080  # 尝试访问8080端口
```

```yaml
spec:
  containers:
    livenessProbe:
      httpGet:
        scheme: HTTP          #支持的协议http或者https
        host: 127.0.0.1       # 主机地址
        port: 80              # 端口号
        path: /index2.html    # URL地址
      initialDelaySeconds: 10
      timeoutSeconds: 20
```

## 重启策略

pod 重启策略： `Always` 默认值，`OnFailure` 容器终止运行且退出码不为0时重启，`Never` 不论何种状态，都不重启

重启延迟时长，10s，20s，40s，80s，160s，300s，300s 是最大重启延迟时长

```yaml
spec:
  restartPolicy: Always       # OnFailure  Never
```

## 调度

1. 自动调度
2. 定向调度 NodeName、NodeSlector  
3. 亲和性、反亲和性调度 NodeAffinity、PodAffinity、PodAntiAffinity
4. 污点(容忍)调度   Taints-污点 、Toleration-容忍

### 自动调度

不指定调度条件，即为自动调度

### 定向调度

NodeName

```yaml
spec:
  nodeName: k8s-node1    # 指定调度到node1
```

NodeSlector

```yaml
spec:
  nodeSelector:
    web: nginx   # 指定调度到具有web=nginx标签的节点上
```

### 亲和性调度

[nodeAffinity](../../k2-scheduling-management/node-affinity.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: node-affinity
  name: node-affinity
  namespace: samples
spec:
  containers:
  - image: nginx:1.21
    imagePullPolicy: IfNotPresent
    name: node-affinity
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution: # 硬亲和
        nodeSelectorTerms:
        - matchExpressions:
          - key: worker
            operator: In
            values:
            - "3"
```

[podAffinity](../../k2-scheduling-management/pod-affinity.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-affinity
  name: pod-affinity
  namespace: samples
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: run
            operator: In
            values:
            - "node-affinity"
        topologyKey: kubernetes.io/hostname
  containers:
  - name: pod-affinity
    image: nginx:1.21
```

[podAntiAnfinity](../../k2-scheduling-management/pod-anti-affinity.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-anti-affinity
  name: pod-anti-affinity
  namespace: samples
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: run
            operator: In
            values:
            - "pod-affinity"
        topologyKey: kubernetes.io/hostname
  containers:
  - name: pod-anti-affinity
    image: nginx:1.21
```

亲和：频繁交互的 pod 越近越好

反亲和：分布式多副本部署，高可用性


### 污点(容忍)调度

[pod-tolerations](../../k2-scheduling-management/pod-tolerations.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-tolerations
  name: pod-tolerations
  namespace: samples
spec:
  containers:
  - name: my-pod
    image: nginx:1.21
  tolerations:
  - key: gpu
    operator: Equal
    value: "yes"
    effect: NoSchedule
```

```shell
# 污点和容忍
# 污点格式 key=value:effect key 和 value 是污点的标签
# effect 支持三个选项：
# [1] PreferNoSchedule   kubernetes 将尽量避免把 pod 调度到具有该污点的 node 上，除非没有其他节点可以调度
# [2] NoSchedule         kubernetes 将不会把pod调度到具有该污点的 node 上，但不影响已经存在于该节点的pod
# [3] NoExecute-不执行   kubernetes 将不会把pod调度到具有该污点的 node 上，同时会把node节点上已经存在的pod驱离

# 设置污点
kubectl taint nodes node1 key=value:effect

# 去除污点
kubectl taint nodes node1 key:effect-

# 去除所有污点
kubectl taint nodes node1 key-
```
