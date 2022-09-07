KinD Yaml Template
===

Using 

```shell
kind create cluster -name xxx-cluster --config=/foo/bar/config.yaml
```

More detail

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
# give your cluster a name
name: app-1-cluster
# Kubernetes feature gates can be enabled cluster-wide across all Kubernetes components with the following config
featureGates:
  # any feature gate can be enabled here with "Name": true
  # or disabled here with "Name": false
  # not all feature gates are tested, however
  "CSIMigration": true
# Kubernetes API server runtime-config can be toggled using the runtimeConfig key, which maps to the --runtime-config kube-apiserver flag. This may be used to e.g. disable beta / alpha APIs.
runtimeConfig:
  "api/alpha": "false"
# Networking configuration
networking:
  ipFamily: ipv6
  # WARNING: It is _strongly_ recommended that you keep this the default
  # (127.0.0.1) for security reasons. However it is possible to change this.
  apiServerAddress: "127.0.0.1"
  # By default the API server listens on a random open port.
  # You may choose a specific port but probably don't need to in most cases.
  # Using a random port makes it easier to spin up multiple clusters.
  apiServerPort: 6443
  # You can configure the subnet used for pod IPs by setting
  podSubnet: "10.244.0.0/16"
  # You can configure the Kubernetes service subnet used for service IPs by setting
  serviceSubnet: "10.96.0.0/12"
  # the default CNI will not be installed
  disableDefaultCNI: true
  # You can configure the kube-proxy mode that will be used, between iptables and ipvs. By default iptables is used
  # To disable kube-proxy, set the mode to "none".
  kubeProxyMode: "ipvs"
# One control plane node and three "workers".
#
# While these will not add more real compute capacity and
# have limited isolation, this can be useful for testing
# rolling updates etc.
#
# The API-server and other control plane components will be
# on the control-plane node.
#
# You probably don't need this unless you are testing Kubernetes itself.
nodes:
# one node hosting a control plane
- role: control-plane
  # add a mount from /path/to/my/files on the host to /files on the node
  extraMounts:
  - hostPath: /path/to/my/files/
    containerPath: /files
    # optional: if set, the mount is read-only.
    # default false
    readOnly: true
    # optional: if set, the mount needs SELinux relabeling.
    # default false
    selinuxRelabel: false
    # optional: set propagation mode (None, HostToContainer or Bidirectional)
    # see https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
    # default None
    propagation: HostToContainer
  # port forward 80 on the host to 80 on this node
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    # optional: set the bind address on the host
    # 0.0.0.0 is the current default
    listenAddress: "127.0.0.1"
    # optional: set the protocol to one of TCP, UDP, SCTP.
    # TCP is the default
    protocol: TCP
  # https://kind.sigs.k8s.io/docs/user/configuration/#kubeadm-config-patches
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
      extraArgs:
        enable-admission-plugins: NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook

- role: worker
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "my-label2=true"
- role: worker
- role: worker
  # You can also set a specific Kubernetes version by setting the node's container image.
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55


```