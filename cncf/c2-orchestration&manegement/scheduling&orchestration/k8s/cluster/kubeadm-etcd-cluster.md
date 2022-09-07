
1. Configure the kubelet to be a service manager for etcd.

Since etcd was created first, you must override the service priority by creating a new unit file that has higher precedence than the kubeadm-provided kubelet unit file.

ubuntu
```bash
cat << EOF | sudo tee /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
# Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
# Replace the value of "--container-runtime-endpoint" for a different container runtime if needed.
ExecStart=/usr/bin/kubelet \
--pod-manifest-path=/etc/kubernetes/manifests \
--cgroup-driver=systemd \
--container-runtime=remote \
--container-runtime-endpoint=unix:///run/containerd/containerd.sock
Restart=always
EOF
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

centos
```bash
cat <<EOF | sudo tee /usr/lib/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
# Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
# Replace the value of "--container-runtime-endpoint" for a different container runtime if needed.
ExecStart=/usr/bin/kubelet \
--pod-manifest-path=/etc/kubernetes/manifests \
--cgroup-driver=systemd \
--container-runtime=remote \
--container-runtime-endpoint=unix:///run/containerd/containerd.sock
Restart=always
EOF
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

2. Generate one kubeadm configuration file for each host that will have an etcd member running on it using the following script.

```bash
# Update HOST0, HOST1 and HOST2 with the IPs of your hosts
export HOST0=10.10.10.10
export HOST1=10.10.10.11
export HOST2=10.10.10.12

# Update NAME0, NAME1 and NAME2 with the hostnames of your hosts
export NAME0="ubuntu-node0"
export NAME1="ubuntu-node1"
export NAME2="ubuntu-node2"

# Create temp directories to store files that will end up on other hosts.
mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

HOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=(${NAME0} ${NAME1} ${NAME2})

for i in "${!HOSTS[@]}"; do
HOST=${HOSTS[$i]}
NAME=${NAMES[$i]}
cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
---
apiVersion: "kubeadm.k8s.io/v1beta3"
kind: InitConfiguration
nodeRegistration:
    name: ${NAME}
localAPIEndpoint:
    advertiseAddress: ${HOST}
---
apiVersion: "kubeadm.k8s.io/v1beta3"
kind: ClusterConfiguration
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${NAMES[0]}=https://${HOSTS[0]}:2380,${NAMES[1]}=https://${HOSTS[1]}:2380,${NAMES[2]}=https://${HOSTS[2]}:2380
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: https://${HOST}:2379
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
EOF
done
```


3. Generate the certificate authority

If you already have a CA then the only action that is copying the CA's crt and key file to /etc/kubernetes/pki/etcd/ca.crt and /etc/kubernetes/pki/etcd/ca.key. After those files have been copied, proceed to the next step, "Create certificates for each member".

If you do not already have a CA then run this command on $HOST0 (where you generated the configuration files for kubeadm).

```bash
sudo kubeadm init phase certs etcd-ca
```

4. Create certificates for each member

```bash
sudo kubeadm init phase certs etcd-server --config=/tmp/${HOST2}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-peer --config=/tmp/${HOST2}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
sudo kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST2}/kubeadmcfg.yaml

sudo cp -R /etc/kubernetes/pki /tmp/${HOST2}/
sudo find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

sudo kubeadm init phase certs etcd-server --config=/tmp/${HOST1}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-peer --config=/tmp/${HOST1}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
sudo kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST1}/kubeadmcfg.yaml

sudo cp -R /etc/kubernetes/pki /tmp/${HOST1}/
sudo find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

sudo kubeadm init phase certs etcd-server --config=/tmp/${HOST0}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-peer --config=/tmp/${HOST0}/kubeadmcfg.yaml
sudo kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
sudo kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
sudo cp -R /etc/kubernetes/pki /tmp/${HOST0}/
# serverCertSANs peerCertSANs is HOST0
sudo find /tmp/${HOST2} -name ca.key -type f -delete
sudo find /tmp/${HOST1} -name ca.key -type f -delete
```

generate files
```bash
$ tree /tmp/
/tmp/
├── 10.10.10.20
│   └── kubeadmcfg.yaml
├── 10.10.10.21
│   ├── kubeadmcfg.yaml
│   └── pki
│       ├── apiserver-etcd-client.crt
│       ├── apiserver-etcd-client.key
│       └── etcd
│           ├── ca.crt
│           ├── healthcheck-client.crt
│           ├── healthcheck-client.key
│           ├── peer.crt
│           ├── peer.key
│           ├── server.crt
│           └── server.key
├── 10.10.10.22
│   ├── kubeadmcfg.yaml
│   └── pki
│       ├── apiserver-etcd-client.crt
│       ├── apiserver-etcd-client.key
│       └── etcd
│           ├── ca.crt
│           ├── healthcheck-client.crt
│           ├── healthcheck-client.key
│           ├── peer.crt
│           ├── peer.key
│           ├── server.crt
│           └── server.key
```

5. Copy certificates and kubeadm configs

The certificates have been generated and now they must be moved to their respective hosts.

```
sudo scp -r /tmp/${HOST1}/kubeadmcfg.yaml root@${HOST1}:/tmp/kubeadmcfg.yaml
sudo scp -r /tmp/${HOST2}/kubeadmcfg.yaml root@${HOST2}:/tmp/kubeadmcfg.yaml
sudo ssh root@${HOST1} mkdir -p /etc/kubernetes/pki/
sudo ssh root@${HOST2} mkdir -p /etc/kubernetes/pki/
sudo scp -r /tmp/${HOST1}/pki/* root@${HOST1}:/etc/kubernetes/pki/
sudo scp -r /tmp/${HOST2}/pki/* root@${HOST2}:/etc/kubernetes/pki/
```

6. Ensure all expected files exist

The complete list of required files on $HOST0 is:

```bash
$ tree /etc/kubernetes/pki/
/etc/kubernetes/pki/
├── apiserver-etcd-client.crt
├── apiserver-etcd-client.key
└── etcd
    ├── ca.crt
    ├── ca.key
    ├── healthcheck-client.crt
    ├── healthcheck-client.key
    ├── peer.crt
    ├── peer.key
    ├── server.crt
    └── server.key

1 directory, 10 files
```

On $HOST1 is:

```bash
$ tree /etc/kubernetes/pki/
/etc/kubernetes/pki/
├── apiserver-etcd-client.crt
├── apiserver-etcd-client.key
└── etcd
    ├── ca.crt
    ├── healthcheck-client.crt
    ├── healthcheck-client.key
    ├── peer.crt
    ├── peer.key
    ├── server.crt
    └── server.key

1 directory, 9 files
```

On $HOST2 is:

```bash
$ tree /etc/kubernetes/pki/
/etc/kubernetes/pki/
├── apiserver-etcd-client.crt
├── apiserver-etcd-client.key
└── etcd
    ├── ca.crt
    ├── healthcheck-client.crt
    ├── healthcheck-client.key
    ├── peer.crt
    ├── peer.key
    ├── server.crt
    └── server.key

1 directory, 9 files
```

7. Create the static pod manifests

Now that the certificates and configs are in place it's time to create the manifests. On each host run the kubeadm command to generate a static manifest for etcd.

```bash
k8s@ubuntu-node0:~$ sudo kubeadm init phase etcd local --config=/tmp/10.10.10.10/kubeadmcfg.yaml
k8s@ubuntu-node1:~$ sudo kubeadm init phase etcd local --config=/tmp/kubeadmcfg.yaml
k8s@ubuntu-node2:~$ sudo kubeadm init phase etcd local --config=/tmp/kubeadmcfg.yaml
```

8. Optional: Check the cluster health

No Docker ?
```bash
sudo docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes bitnami/etcd:3.5.4 etcdctl \
--cert /etc/kubernetes/pki/etcd/peer.crt \
--key /etc/kubernetes/pki/etcd/peer.key \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://10.10.10.10.:2379 endpoint health --cluster
```
...
https://[HOST0 IP]:2379 is healthy: successfully committed proposal: took = 16.283339ms
https://[HOST1 IP]:2379 is healthy: successfully committed proposal: took = 19.44402ms
https://[HOST2 IP]:2379 is healthy: successfully committed proposal: took = 35.926451ms