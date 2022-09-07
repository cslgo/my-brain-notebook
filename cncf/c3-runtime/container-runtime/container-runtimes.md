[Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
===

> Note: Dockershim has been removed from the Kubernetes project as of release 1.24. Read the Dockershim Removal FAQ for further details.

You need to install a container runtime into each node in the cluster so that Pods can run there. This page outlines what is involved and describes related tasks for setting up nodes.

Kubernetes 1.24 requires that you use a runtime that conforms with the Container Runtime Interface (CRI).

## Cgroup drivers 

## Container runtimes

### [containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

This section outlines the necessary steps to use containerd as CRI runtime.

Use the following commands to install Containerd on your system:

#### Install and configure prerequisites

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

#### Install containerd

Visit [Getting started with containerd](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) and follow the instructions there, up to the point where you have a valid configuration file, config.toml. On Linux, you can find this file under the path /etc/containerd/config.toml. On Windows, you can find this file under the path C:\Program Files\containerd\config.toml.

On Linux the default CRI socket for containerd is /run/containerd/containerd.sock. On Windows the default CRI endpoint is npipe://./pipe/containerd-containerd.

## Configuring the systemd cgroup driver

To use the `systemd` cgroup driver in `/etc/containerd/config.toml` with `runc`, set

```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```
If you apply this change, make sure to restart containerd:

```bash
sudo systemctl restart containerd
```

When using kubeadm, manually configure the [cgroup driver for kubelet](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-control-plane-node).


## Reference Link

https://kubernetes.io/docs/setup/production-environment/container-runtimes/

https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
