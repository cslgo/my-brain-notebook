client-go
===

在 K8s 运维中，我们可以使用 kubectl、客户端库或者 REST 请求来访问 K8s API。而实际上，无论是 kubectl 还是客户端库，都是封装了 REST 请求的工具。client-go 作为一个客户端库，能够调用 K8s API，实现对 K8s 集群中资源对象（包括 deployment、service、Ingress、ReplicaSet、Pod、Namespace、Node 等）的增删改查等操作。


