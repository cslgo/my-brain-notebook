使用 Go 从零开发并发布一个 Kubectl 插件
===

## 前言

十年云计算浪潮下，DevOps、容器、微服务等技术飞速发展，云原生成为潮流。企业云化从“ON Cloud” 走向 “IN Cloud”，成为“新云原生企业”，新生能力与既有能力立而不破、有机协同，实现资源高效、应用敏捷、业务智能、安全可信。整个云原生概念很大，细化到可能是我们在真实场景中遇到的一些小问题，本文就针对日常工作中遇到的自己的小需求，及解决思路方法，分享给大家。

## 背景

在我日常使用 kubectl 查看 K8s 资源的时候，想直接查看对应资源的容器名称和镜像名称，目前 kubectl 还不支持该选型，需要我们 describe 然后来查看，对于集群自己比较多，不是很方便，因此萌生了自己开发 kubectl 插件来实现该功能。


## 相关技术

首先需要调用 Kubernetes 需要使用 client-go 项目来实现对 Kubernetes 资源的获取，对于插件使用 Golang 语言开发，因为是客户端执行，为了方便集成到及命令行工具，采用和 K8s 相同的命令行脚手架工具 Cobra，最后将其开源发布到 GitHub。

### Golang

在云原生开发中，Google 非常多的开源项目都是使用 Golang 开发，其跨平台编译后可以发布到多个平台，我们开发的插件基于 Golang，后续也就支持多平台使用。

### Cobra

Cobra 是一个命令行程序库，其是一个用来编写命令行的神器，提供了一个脚手架，用于快速生成基于 Cobra 应用程序框架。我们可以利用 Cobra 快速的去开发出我们想要的命令行工具，非常的方便快捷。

### Client-go

在 K8s 运维中，我们可以使用 kubectl、客户端库或者 REST 请求来访问 K8s API。而实际上，无论是 kubectl 还是客户端库，都是封装了 REST 请求的工具。client-go 作为一个客户端库，能够调用 K8s API，实现对 K8s 集群中资源对象（包括 deployment、service、Ingress、ReplicaSet、Pod、Namespace、Node 等）的增删改查等操作。

### krew

Krew 是 类似于系统的 apt、dnf 或者 brew 的 kubectl 插件包管理工具，利用其可以轻松的完成 kubectl 插件的全上面周期管理，包括搜索、下载、卸载等。

kubectl 其工具已经比较完善，但是对于一些个性化的命令，其宗旨是希望开发者能以独立而紧张形式发布自定义的 kubectl 子命令，插件的开发语言不限，需要将最终的脚步或二进制可执行程序以 kubectl- 的前缀命名，然后放到 PATH 中即可，可以使用 kubectl plugin list 查看目前已经安装的插件。

### Github 发布相关工具

#### GitHub Action

如果你需要某个 Action，不必自己写复杂的脚本，直接引用他人写好的 Action 即可，整个持续集成过程，就变成了一个 Actions 的组合。Github[1]是做了一个商店的功能。这样大家就可以自己定义自己的 Action，然后方便别人复用。同时也可以统一自己的或者组织在构建过程中的一些公共流程。

#### GoReleaser

GoReleaser 采用 Golang 开发，是一款用于 Golang 项目的自动发布工具。无需太多配置，只需要几行命令就可以轻松实现跨平台的包编译、打包和发布到 Github、Gitlab 等版本仓库种。

## 插件规划

* 插件命名为：kubectl-img
* 目前仅简单实现一个 image 命令，用于查看不同资源对象 (deployments/daemonsets/statefulsets/jobs/cronjobs) 的名称，和对应容器名称，镜像名称。
* 支持 JSON 格式输出。
* 最后将其作为 krew 插件使用。
* 可以直接根据名称空间来进行查看对应资源

## 开发

### 项目初始化

#### 安装 Cobra

在开发环境中安装 Cobra，后去基于改命令行工具来生成项目脚手架，K8s 中很多组建也是用的改框架来生成的。

```bash
go get -u github.com/spf13/cobra@latest
go install github.com/spf13/cobra-cli@latest
```

#### 初始化项目

```bash
$ cobra-cli init --pkg-name kubectl-img
$ ls
LICENSE cmd     main.go
$ tree
├── LICENSE
├── cmd
│   └── root.go
└── main.go
```

#### 增加子命令

增加一个子命令 image，在此为我们的插件添加子命令。

```bash
cobra-cli add image
```

#### 添加参数

通过子命令+flag 形式，显示不同的资源镜像名称。

```go
func Execute() {
 cobra.CheckErr(rootCmd.Execute())
}

func init() {
 KubernetesConfigFlags = genericclioptions.NewConfigFlags(true)
 imageCmd.Flags().BoolP("deployments", "d", false, "show deployments image")
 imageCmd.Flags().BoolP("daemonsets", "e", false, "show daemonsets image")
 imageCmd.Flags().BoolP("statefulsets", "f", false, "show statefulsets image")
 imageCmd.Flags().BoolP("jobs", "o", false, "show jobs image")
 imageCmd.Flags().BoolP("cronjobs", "b", false, "show cronjobs image")
 imageCmd.Flags().BoolP("json", "j", false, "show json format")
 KubernetesConfigFlags.AddFlags(rootCmd.PersistentFlags())
}
```

