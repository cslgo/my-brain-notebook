Intalling Kubernetes Cluster with VMware Fusion in Ubuntu
===

## Before Intallation

[VMware Fusion Ubuntu Server Installation](notes/linux/ubuntu/vmw-fusion/README.md)

Verify the MAC address and product_uuid are unique for every node
```bash
ip link # or ifconfig -a

sudo apt update && sudo apt -y upgrade
sudo reboot

sudo apt install -y ntpdate
sudo ntpdate time.windows.com

sudo swapoff -a
sudo cat /sys/class/dmi/id/product_uuid
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab
uname -a
```

Check required ports
```bash
nc 127.0.0.1 6443
```

Hosts
```
# K8s
cat <<EOF | sudo tee -a /etc/hosts 
10.10.10.10 ubuntu-node0
10.10.10.11 ubuntu-node1
10.10.10.12 ubuntu-node2
10.10.10.13 ubuntu-node3
10.10.10.14 ubuntu-node4
10.10.10.15 ubuntu-node5
EOF
```

### Installing containerd

Before installation module is loaded

Check network br_netfilter
```bash
lsmod | grep br_netfilter
```

```bash
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
```

Setup required sysctl params, these persist across reboots.
```bash
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

Apply sysctl params without reboot
```bash
sudo sysctl --system
```

[Cgroup drivers](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers)

On Linux, control groups are used to constrain resources that are allocated to processes.

Both kubelet and the underlying container runtime need to interface with control groups to enforce resource management for pods and containers and set resources such as cpu/memory requests and limits. To interface with control groups, the kubelet and the container runtime need to use a cgroup driver. It's critical that the kubelet and the container runtime uses the same cgroup driver and are configured the same.

There are two cgroup drivers available:

- [cgroupfs](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroupfs-cgroup-driver)
- [systemd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)

[Using systemd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)

```bash
```
If you configure systemd as the cgroup driver for the kubelet, you must also configure systemd as the cgroup driver for the container runtime. Refer to the documentation for your container runtime for instructions


[Installing containerd](./containerd.md#installing-containerd)

Visit Getting started with containerd and follow the instructions there, up to the point where you have a valid configuration file, config.toml. On Linux, you can find this file under the path `/etc/containerd/config.toml`. On Windows, you can find this file under the path `C:\Program Files\containerd\config.toml`.

[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

1. Set up the repository
```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

2. Add Docker’s official GPG key:
```bash
sudo mkdir -p /etc/apt/keyrings
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
// Or
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/apt-key.gpg --import

```

3. Use the following command to set up the stable repository. To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below. Learn about nightly and test channels.

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the apt package index, and install the latest version of Docker Engine, containerd, and Docker Compose, or go to the next step to install a specific version:

```bash
sudo apt-get update
sudo apt-get install -y containerd.io
```

Config containerd
```bash

sudo scp root@10.10.10.10:/etc/containerd/config.toml /etc/containerd/config.toml
## or
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo sed -i 's#sandbox_image = "k8s.gcr.io/pause#sandbox_image = "registry.aliyuncs.com/google_containers/pause#g' /etc/containerd/config.toml
```

Configuring the systemd cgroup driver 

To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set
```yaml
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        # 如下这些仓库可以作为公共仓库使用
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
            endpoint = ["https://docker.mirrors.ustc.edu.cn","http://hub-mirror.c.163.com","https://b9pmyelo.mirror.aliyuncs.com"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
            endpoint = ["https://gcr.mirrors.ustc.edu.cn"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
            endpoint = ["https://gcr.mirrors.ustc.edu.cn/google-containers/"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
            endpoint = ["https://gcr.mirrors.ustc.edu.cn/google-containers/"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."quay.io"]
            endpoint = ["https://quay.mirrors.ustc.edu.cn"]
```

```bash
sudo systemctl daemon-reload && sudo systemctl restart containerd
```

Install crictl

`sudo vim /etc/crictl.yaml`
```bash
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: true
EOF
```
Or
```bash
sudo scp root@10.10.10.10:/etc/crictl.yaml /etc/crictl.yaml
```

```bash
VERSION="v1.25.0"
curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-amd64.tar.gz --output crictl-${VERSION}-linux-amd64.tar.gz && \
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin && \
rm -f crictl-$VERSION-linux-amd64.tar.gz
```

## Installing kubeadm, kubelet and kubectl

### Debian-based distributions
所有节点安装 apt-transport-https

1. Update the apt package index and install packages needed to use the Kubernetes apt repository:
```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
```

2. Add the Kubernetes apt repository:

Aliyun mirror: Debian / Ubuntu

```bash
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/apt-key.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/apt-key.gpg
echo "deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
```

Official
```bash
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

4. Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

Debian / Ubuntu
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```

The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it what to do.


__Note: In v1.22, if the user is not setting the cgroupDriver field under KubeletConfiguration, kubeadm will default it to systemd.__

When container runtime = containerd < v1.22
```bash
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
# Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
# Replace the value of "--container-runtime-endpoint" for a different container runtime if needed.
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd --container-runtime=remote --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock
Restart=always
EOF
sudo systemctl daemon-reload && sudo systemctl restart kubelet 
sudo systemctl status kubelet

```

## Build Kubernetes Cluster

In K8s Master Node

```bash
sudo kubeadm init \
  --apiserver-advertise-address=10.10.10.13 \
  --kubernetes-version v1.25.0 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --image-repository registry.aliyuncs.com/google_containers \
  --ignore-preflight-errors=all
  
```

reset

```bash
sudo swapoff -a && \
sudo kubeadm reset && \
sudo iptables -F && \
sudo iptables -t nat -F && \
sudo iptables -t mangle -F && \
sudo iptables -X && \
sudo rm -rf /var/lib/containerd && \
sudo systemctl daemon-reload && \
sudo systemctl restart containerd && \
sudo systemctl restart kubelet 
```


## 问题解决

When
```
nodes "ubuntu-node3" not found
Error writing Crisocket information for the control-plane node
```

Then delete conf file
```
sudo rm -rf /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
sudo systemctl daemon-reload && sudo systemctl stop kubelet 
```



## Reference Link

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
- https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/
- https://github.com/containerd/containerd/blob/main/docs/getting-started.md
- https://docs.docker.com/engine/install/ubuntu/
