Installing Kubernetes Cluster with CentOS Linux
===

## Before Installing

[Installing CentOS VM in VMware Fusion](Installing%20CentOS%20with%20VMware%20Fusion.md)

Tips：可先安装单个 vm，待配置好公共环境后再进行克隆多个节点，针对每个克隆节点做必要的环境设置，比如 hostname ，ip 等。

```bash
# Disable firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# Disable selinux
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo setenforce 0
# Disable swap
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab
sudo swapoff -a
# Modify hostname，this can be executed later after the basic components are installed and cloned.
sudo hostnamectl set-hostname <hostname>
# Config hosts
cat <<EOF | sudo tee -a /etc/hosts 
10.10.10.20 centos-node0
10.10.10.21 centos-node1
10.10.10.22 centos-node2
10.10.10.23 centos-node3
10.10.10.24 centos-node4
10.10.10.25 centos-node5
10.10.10.26 centos-node6
EOF

# Make sure that the br_netfilter module is loaded.
sudo lsmod | grep br_netfilter
sudo modprobe br_netfilter

# Pass bridged IPv4 traffic to iptables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# ntpdate
sudo yum install ntpdate -y
sudo ntpdate time.windows.com
```

## Installing Container Runtimes

### Option 1: docker engin

Using aliyun mirrors
```bash
sudo curl https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
#sudo yum -y install containerd
sudo yum -y install docker-ce
#sudo systemctl enable containerd && sudo systemctl restart containerd
sudo systemctl enable docker && sudo systemctl restart docker
```

Docker Configuration
```bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl restart docker
```

### Option 2: containerd

Install and configure prerequisites:
```bash
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

Install containerd:
```bash
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

Configuring the systemd cgroup driver 

To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set

```
   [plugins."io.containerd.grpc.v1.cri"]
      sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.6"  
         ...
         [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
             SystemdCgroup = true
             ...
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://b9pmyelo.mirror.aliyuncs.com"]
```

If you apply this change, make sure to restart containerd:

```bash
sudo systemctl daemon-reload && sudo systemctl restart containerd
```

Config kubelet use containerd

cat /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
```conf
KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --cgroup-driver=systemd
```
Or
```bash
cat <<EOF | sudo tee /usr/lib/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
# Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
# Replace the value of "--container-runtime-endpoint" for a different container runtime if needed.
ExecStart=/usr/bin/kubelet \
--address=127.0.0.1 \
--pod-manifest-path=/etc/kubernetes/manifests \
--cgroup-driver=systemd \
--container-runtime=remote \
--container-runtime-endpoint=unix:///run/containerd/containerd.sock
Restart=always
EOF

sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

## Installing Kubernetes

Using aliyun kubernetes mirrors
```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo 
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

Intalling
```bash

sudo yum install -y kubelet-1.24.3 kubeadm-1.24.3 kubectl-1.24.3 --disableexcludes=kubernetes

sudo systemctl enable --now kubelet
```

When container runtime = containerd < 1.22.0 then `vi /etc/sysconfig/kubelet`
```conf
KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --cgroup-driver=systemd
```
```bash
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

公共安装结束
---

## Build Kubernetes Cluster

In K8s Master Node
```bash
sudo kubeadm init \
  --apiserver-advertise-address=10.10.10.23 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.24.3 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=all
```

To start using your cluster, you need to run the following as a regular user:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Then you can join any number of worker nodes by running the following on each as root:

```bash
kubeadm join 10.10.10.20:6443 --token b79lqk.murt2xx2a06q8vx8 \
        --discovery-token-ca-cert-hash sha256:5a6ce4bd356127f26b02a72987d989dfc2a8cd12513c4c51ab16cc649aaeba32
```

If token expired 24 hours using:
```bash
kubeadm token create --print-join-command
```

## Deploy CNI Calico

On master node
```bash
wget https://docs.projectcalico.org/manifests/calico.yaml
```

After downloading, you need to modify the definition of the Pod network (CALICO_IPV4POOL_CIDR), which is the same as that specified by --pod-network-cidr of kubeadm init.

```yaml
            - name: CALICO_IPV4POOL_CIDR
              value: "10.244.0.0/16"
```

```bash
kubectl apply -f calico.yaml
kubectl get pods -n kube-system
```

Kubernetes configure dictionary:

```bash
cd /etc/kubernetes/
cd /etc/kubernetes/manifests
```

## Reference Link

[国内镜像](https://kubernetes.feisky.xyz/appendix/mirrors)

