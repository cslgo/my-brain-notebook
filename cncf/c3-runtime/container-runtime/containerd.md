containerd
===

## Installing containerd

### [Option 1：From the official binaries](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#option-1-from-the-official-binaries)

### [Option 2: From apt-get or dnf](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#option-2-from-apt-get-or-dnf)

The containerd.io packages in DEB and RPM formats are distributed by Docker (not by the containerd project). See the Docker documentation for how to set up apt-get or dnf to install containerd.io packages:

* [CentOS](https://docs.docker.com/engine/install/centos/)
* [Debian](https://docs.docker.com/engine/install/debian/)
* [Fedora](https://docs.docker.com/engine/install/fedora/)
* [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
  
The containerd.io package contains runc too, but does not contain CNI plugins.

### [Option 3: From source](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#option-3-from-source)

## Reference Link

[getting-started](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)


## Setting crictl connect to containerd

https://github.com/kubernetes-sigs/cri-tools/

vi /etc/crictl.yaml

```yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
```

To restart containerd

```bash
sudo systemctl daemon-reload && sudo systemctl restart containerd

```





