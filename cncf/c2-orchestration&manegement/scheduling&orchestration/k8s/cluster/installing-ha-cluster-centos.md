Installing a HA k8s cluster with External etcd topology
===

![Stacked etcd topology](https://d33wubrfki0l68.cloudfront.net/d1411cded83856552f37911eb4522d9887ca4e83/b94b2/images/kubeadm/kubeadm-ha-topology-stacked-etcd.svg)

![External etcd topology](https://d33wubrfki0l68.cloudfront.net/ad49fffce42d5a35ae0d0cc1186b97209d86b99c/5a6ae/images/kubeadm/kubeadm-ha-topology-external-etcd.svg)

```
centos-node0    10.10.10.20     containerd  etcd     nginx   keepalived
centos-node1	10.10.10.21	    containerd  etcd     nginx   keepalived
centos-node2	10.10.10.22	    containerd  etcd
VIP  10.10.10.99
```

## CentOS Initialize

```bash
# 关闭防火墙
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 关闭selinux
sudo sed -i 's/enforcing/disabled/' /etc/selinux/config  # 永久
sudo setenforce 0  # 临时

# 关闭swap
sudo swapoff -a  # 临时
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab    # 永久

# 根据规划设置主机名
sudo hostnamectl set-hostname <hostname>

# 在master添加hosts
cat <<EOF |sudo tee -a /etc/hosts 
10.10.10.20 centos-node0
10.10.10.21 centos-node1
10.10.10.22 centos-node2
EOF

# 将桥接的IPv4流量传递到iptables的链
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system  # 生效

# 时间同步
sudo yum install ntpdate -y
sudo ntpdate time.windows.com
```

## Nginx + Keepalived HA Configuration

```bash
# 
sudo yum install epel-release -y
sudo yum install nginx keepalived -y
```

Nginx Configuration
```bash
cat <<EOF | sudo tee /etc/nginx/nginx.conf 
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

# 四层负载均衡，为两台Master apiserver组件提供负载均衡
stream {

    log_format  main  '$remote_addr $upstream_addr - [$time_local] $status $upstream_bytes_sent';

    access_log  /var/log/nginx/k8s-access.log  main;

    upstream k8s-apiserver {
        server 10.10.10.20:6443;   # Master1 APISERVER IP:PORT
        server 10.10.10.21:6443;   # Master2 APISERVER IP:PORT
    }
    
    server {
        listen 16443;  # 由于nginx与master节点复用，这个监听端口不能是6443，否则会冲突
        proxy_pass k8s-apiserver;
    }
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
}
EOF
```

nginx[69898]: nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/nginx.conf:13
```
nginx -V | grep  stream

sudo yum search stream | grep nginx
sudo yum install -y  nginx-mod-stream
```

Keepalived Configuration (Nginx Master)

```bash
cat << EOF | sudo tee /etc/keepalived/keepalived.conf
global_defs { 
    notification_email { 
        acassen@firewall.loc 
        failover@firewall.loc 
        sysadmin@firewall.loc 
    } 
    notification_email_from Alexandre.Cassen@firewall.loc  
    smtp_server 127.0.0.1 
    smtp_connect_timeout 30 
    router_id NGINX_MASTER
} 

vrrp_script check_nginx {
    script "/etc/keepalived/check_nginx.sh" # 判断返回状态码
}

vrrp_instance VI_1 { 
    state MASTER 
    interface ens33         # 修改为实际网卡名
    virtual_router_id 51    # VRRP 路由 ID实例，每个实例是唯一的 
    priority 100            # 优先级，备服务器设置 90 
    advert_int 1            # 指定VRRP 心跳包通告间隔时间，默认1秒 
    authentication { 
        auth_type PASS      
        auth_pass 1111 
    }
    # 虚拟IP
    virtual_ipaddress { 
        10.10.10.99/24
    } 
    track_script {
        check_nginx
    } 
}
EOF
```

Keepalived Configuration (Nginx Slave)
```bash
cat << EOF | sudo tee  /etc/keepalived/keepalived.conf
global_defs { 
    notification_email { 
        acassen@firewall.loc 
        failover@firewall.loc 
        sysadmin@firewall.loc 
    } 
    notification_email_from Alexandre.Cassen@firewall.loc  
    smtp_server 127.0.0.1 
    smtp_connect_timeout 30 
    router_id NGINX_BACKUP
} 

vrrp_script check_nginx {
    script "/etc/keepalived/check_nginx.sh"
}

vrrp_instance VI_1 { 
    state BACKUP 
    interface ens33
    virtual_router_id 51    #VRRP 路由 ID 实例，每个实例是唯一的 
    priority 90
    advert_int 1
    authentication { 
        auth_type PASS      
        auth_pass 1111 
    }  
    virtual_ipaddress { 
        10.10.10.99/24
    } 
    track_script {
        check_nginx
    } 
}
EOF
```

Health check script: /etc/keepalived/check_nginx.sh

```bash
cat <<EOF | sudo tee /etc/keepalived/check_nginx.sh
#!/bin/bash
code=$(curl -k https://127.0.0.1:16443/version -s -o /dev/null -w %{http_code})

if [ "$code" -ne 200 ];then
    exit 1
else
    exit 0
fi
EOF

sudo chmod +x /etc/keepalived/check_nginx.sh
```

查看 keepalived VIP 状态及日志
```bash
ip addr
sudo journalctl -u keepalived -f
```

## 启动并设置开机启动

```bash
sudo systemctl daemon-reload
sudo systemctl start nginx
sudo systemctl start keepalived
sudo systemctl enable nginx
sudo systemctl enable keepalived
```
check status
```bash
ip addr
```
ens33 网卡绑定了 10.10.10.99 虚拟 IP，说明正常工作

## HA test

Kill 掉 Nginx master 验证 Nginx 漂移至 Slave 节点实例 

## Etcd Configuration

节点设计：

```
etcd0 10.10.10.20
etcd1 10.10.10.21
etcd2 10.10.10.22
```

可选，使用 cfssl 证书生产：
```bash
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
sudo mv cfssl-certinfo_linux-amd64 /usr/bin/cfssl-certinfo
```

```bash
mkdir -p ~/etcd_tls
cd ~/etcd_tls
```

CA
```bash
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "www": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

cat > ca-csr.json << EOF
{
    "CN": "etcd CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Beijing",
            "ST": "Beijing"
        }
    ]
}
EOF
```
Create `ca.pem` `ca.key`
```bash
sudo cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
```

使用 CA 签发 Etcd  https 安全证书
```bash
cat > server-csr.json << EOF
{
    "CN": "etcd",
    "hosts": [
    "10.10.10.20",
    "10.10.10.21",
    "10.10.10.22"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing"
        }
    ]
}
EOF
```

Create server.pem server.key
```bash
sudo cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | sudo cfssljson -bare server
```

**建议可以 kubeadm phase 生产证书，具体 [see 2-4](kubeadm-etcd-cluster.md)**

```bash
export HOST0=10.10.10.20
export HOST1=10.10.10.21
export HOST2=10.10.10.22

# Update NAME0, NAME1 and NAME2 with the hostnames of your hosts
export NAME0="centos-node0"
export NAME1="centos-node1"
export NAME2="centos-node2"

[generate etcd certs](kubeadm-etcd-cluster.md)

sudo find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete
sudo cp /tmp/${HOST0}/pki/etcd/* /etc/etcd/tls/
sudo cp -r /tmp/${HOST0}/pki/apiserver-etcd-client.* /etc/kubernetes/pki/
sudo cp -r /tmp/${HOST0}/pki/etcd/ca.* /etc/kubernetes/pki/etcd/

sudo ssh root@${HOST1} mkdir -p /etc/etcd/tls/
sudo scp -r /tmp/${HOST1}/pki/etcd/* root@${HOST1}:/etc/etcd/tls/
sudo ssh root@${HOST1} mkdir -p /etc/kubernetes/pki/etcd
sudo scp -r /tmp/${HOST1}/pki/apiserver-etcd-client.* root@${HOST1}:/etc/kubernetes/pki/
sudo scp -r /tmp/${HOST1}/pki/etcd/ca.crt root@${HOST1}:/etc/kubernetes/pki/etcd

sudo ssh root@${HOST2} mkdir -p /etc/etcd/tls/
sudo scp -r /tmp/${HOST2}/pki/etcd/* root@${HOST2}:/etc/etcd/tls/
sudo ssh root@${HOST2} mkdir -p /etc/kubernetes/pki/etcd
sudo scp -r /tmp/${HOST2}/pki/apiserver-etcd-client.* root@${HOST2}:/etc/kubernetes/pki/
sudo scp -r /tmp/${HOST2}/pki/etcd/ca.crt root@${HOST2}:/etc/kubernetes/pki/etcd

#sudo scp -r /tmp/${HOST1}/kubeadmcfg.yaml root@${HOST1}:/tmp/kubeadmcfg.yaml
#sudo scp -r /tmp/${HOST2}/kubeadmcfg.yaml root@${HOST2}:/tmp/kubeadmcfg.yaml
```

## 部署 Etcd 集群

Download Etcd binary
```bash
wget https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
```

各节点处理
```bash
tar zxvf etcd-v3.5.4-linux-amd64.tar.gz
sudo mkdir /etc/etcd/{cfg,tls} -p
sudo mv etcd-v3.5.4-linux-amd64/{etcd,etcdctl,etcdutl} /usr/bin/
```

etcd config etcd0
```bash
cat <<EOF | sudo tee /etc/etcd/cfg/etcd.conf
#[Member]
ETCD_NAME="etcd0"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.10.10.20:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.10.10.20:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.10.10.20:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.10.10.20:2379"
ETCD_INITIAL_CLUSTER="etcd0=https://10.10.10.20:2380,etcd1=https://10.10.10.21:2380,etcd2=https://10.10.10.22:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF
```

etcd config etcd1
```bash
cat <<EOF | sudo tee /etc/etcd/cfg/etcd.conf
#[Member]
ETCD_NAME="etcd1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.10.10.21:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.10.10.21:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.10.10.21:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.10.10.21:2379"
ETCD_INITIAL_CLUSTER="etcd0=https://10.10.10.20:2380,etcd1=https://10.10.10.21:2380,etcd2=https://10.10.10.22:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF
```

etcd config etcd2
```bash
cat <<EOF | sudo tee /etc/etcd/cfg/etcd.conf
#[Member]
ETCD_NAME="etcd2"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.10.10.22:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.10.10.22:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.10.10.22:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.10.10.22:2379"
ETCD_INITIAL_CLUSTER="etcd0=https://10.10.10.20:2380,etcd1=https://10.10.10.21:2380,etcd2=https://10.10.10.22:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF
```

etcd systemd
```bash
cat << EOF | sudo tee /usr/lib/systemd/system/etcd.service 
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=/etc/etcd/cfg/etcd.conf
ExecStart=/usr/bin/etcd \
--cert-file=/etc/etcd/tls/server.pem \
--key-file=/etc/etcd/tls/server-key.pem \
--trusted-ca-file=/etc/etcd/tls/ca.pem \
--peer-cert-file=/etc/etcd/tls/server.pem \
--peer-key-file=/etc/etcd/tls/server-key.pem \
--peer-trusted-ca-file=/etc/etcd/tls/ca.pem \
--logger=zap
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
```

```bash
sudo cp ~/etcd_tls/ca*pem ~/etcd_tls/server*pem /etc/etcd/tls/

scp -r /etc/etcd/ root@10.10.10.21:/etc/
scp -r /etc/etcd/ root@10.10.10.22:/etc/
scp /usr/lib/systemd/system/etcd.service root@10.10.10.21:/usr/lib/systemd/system/
scp /usr/lib/systemd/system/etcd.service root@10.10.10.21:/usr/lib/systemd/system/
```

Check etcd status
```bash
ETCDCTL_API=3 sudo etcdctl --cacert=/etc/etcd/tls/ca.pem --cert=/etc/etcd/tls/server.pem --key=/etc/etcd/tls/server-key.pem --endpoints="https://10.10.10.20:2379,https://10.10.10.21:2379,https://10.10.10.22:2379" endpoint health --write-out=table
```

When: etcd systemd using `kubeadm init phase certs etcd-ca`

```bash
cat <<EOF | sudo tee /usr/lib/systemd/system/etcd.service 
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=/etc/etcd/cfg/etcd.conf
ExecStart=/usr/bin/etcd \
--cert-file=/etc/etcd/tls/server.crt \
--key-file=/etc/etcd/tls/server.key \
--trusted-ca-file=/etc/etcd/tls/ca.crt \
--peer-cert-file=/etc/etcd/tls/peer.crt \
--peer-key-file=/etc/etcd/tls/peer.key \
--peer-trusted-ca-file=/etc/etcd/tls/ca.crt \
--logger=zap
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
```

```bash
sudo systemctl daemon-reload && sudo systemctl start etcd
sudo systemctl enable etcd
```

Check etcd status
```bash
ETCDCTL_API=3 sudo etcdctl --cacert=/etc/etcd/tls/ca.crt --cert=/etc/etcd/tls/server.crt --key=/etc/etcd/tls/server.key --endpoints="https://10.10.10.20:2379,https://10.10.10.21:2379,https://10.10.10.22:2379" endpoint health --write-out=table
```

## 安装 kubeadm kubelet kubectl

Installing [see](Installing%20Kubernetes%20Cluster.md)

Init Master1 Configuration `sudo kubeadm config print init-defaults`

```bash
cat << EOF | tee kubeadm-config.yaml 
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 10.10.10.20
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: centos-node0
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  certSANs: #包含所有Master/LB/VIP IP，一个都不能少！为了方便后期扩容可以多写几个预留的IP。
  - centos-node0
  - centos-node1
  - 10.10.10.20
  - 10.10.10.21
  - 10.10.10.22
  - 10.10.10.99
  - 127.0.0.1
  extraArgs:
    authorization-mode: Node,RBAC
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controlPlaneEndpoint: 10.10.10.99:16443 #负载均衡虚拟IP（VIP）和端口
etcd:
  external:  # 使用外部etcd
    endpoints:
    - https://10.10.10.20:2379      #etcd集群3个节点
    - https://10.10.10.21:2379
    - https://10.10.10.22:2379
    caFile: /etc/kubernetes/pki/etcd/ca.crt
    certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
    keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: 1.25.0       #K8s版本，与上面安装的一致
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16      #Pod网络，与下面部署的CNI网络组件yaml中保持一致
  serviceSubnet: 10.96.0.0/12   #集群内部虚拟网络，Pod统一访问入口
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF
```

export CONTROL_PLANE="ubuntu@10.0.0.7"
scp /etc/kubernetes/pki/etcd/ca.crt "${CONTROL_PLANE}":
scp /etc/kubernetes/pki/apiserver-etcd-client.crt "${CONTROL_PLANE}":
scp /etc/kubernetes/pki/apiserver-etcd-client.key "${CONTROL_PLANE}":

Init
```bash
sudo kubeadm init phase upload-certs --upload-certs --config kubeadm-config.yaml
sudo kubeadm init \
    --config kubeadm-config.yaml  \
    --upload-certs  \
    --ignore-preflight-errors=all --v=5
```

If `kubeadm init` no `--upload-certs` flag need to install [ssh](notes/linux/ssh.md)  and copy the certificates from the first control plane node to the other control plane nodes

```bash
su -

USER=slcho
CONTROL_PLANE_IPS="10.10.10.21"
for host in ${CONTROL_PLANE_IPS}; do
    scp /etc/kubernetes/pki/ca.crt "${USER}"@$host:
    scp /etc/kubernetes/pki/ca.key "${USER}"@$host:
    scp /etc/kubernetes/pki/sa.key "${USER}"@$host:
    scp /etc/kubernetes/pki/sa.pub "${USER}"@$host:
    scp /etc/kubernetes/pki/front-proxy-ca.crt "${USER}"@$host:
    scp /etc/kubernetes/pki/front-proxy-ca.key "${USER}"@$host:
    scp /etc/kubernetes/pki/etcd/ca.crt "${USER}"@$host:etcd-ca.crt
    # Skip the next line if you are using external etcd
    scp /etc/kubernetes/pki/etcd/ca.key "${USER}"@$host:etcd-ca.key
done
```

Then on each joining control plane node you have to run the following script before running kubeadm join

```bash
su - 

USER=slcho
mkdir -p /etc/kubernetes/pki/etcd
mv /home/${USER}/ca.crt /etc/kubernetes/pki/
mv /home/${USER}/ca.key /etc/kubernetes/pki/
mv /home/${USER}/sa.pub /etc/kubernetes/pki/
mv /home/${USER}/sa.key /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.key /etc/kubernetes/pki/
mv /home/${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
# Skip the next line if you are using external etcd
mv /home/${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
```

Finished print out logs
```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 10.10.10.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:77946fdaa49f4abd9c3015461d6f2b065ed1680fa8e607b806e7c0c9eb1e3430 \
        --control-plane --certificate-key 0e14f1f9217b5a4f73d4e39f396365fa288b7a67e623c970a4bc35a86a8c3593 --v=5

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.10.10.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:77946fdaa49f4abd9c3015461d6f2b065ed1680fa8e607b806e7c0c9eb1e3430
```

Service  status check

```bash
sudo systemctl status kubelet
sudo systemctl status containerd
sudo systemctl status nginx
sudo systemctl status keepalived

sudo journalctl -u kubelet -f
sudo journalctl -u containerd -f
sudo journalctl -u nginx -f
sudo journalctl -u keepalived -f
```

## 如若遇到问题

```
[preflight] Some fatal errors occurred:
        [ERROR Port-10250]: Port 10250 is in use
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
error execution phase preflight
```

可尝试 `kubeadm reset` 解决
```bash
sudo kubeadm reset
sudo systemctl restart kubelet
```

nodes "centos-node0" not found
Error writing Crisocket information for the control-plane node

```
sudo swapoff -a && \
sudo kubeadm reset && \
sudo iptables -F && \
sudo iptables -t nat -F && \
sudo iptables -t mangle -F && \
sudo iptables -X && \
sudo rm -rf /var/lib/containerd && \
sudo systemctl daemon-reload && \
sudo systemctl restart containerd && \
sudo systemctl restart kubelet && \
sudo mkdir -p /etc/kubernetes/pki/etcd && \
sudo cp -r /tmp/10.10.10.20/pki/apiserver-etcd-client.* /etc/kubernetes/pki/ && \
sudo cp -r /tmp/10.10.10.20/pki/etcd/ca.* /etc/kubernetes/pki/etcd/
```

When
```
nodes "ubuntu-node3" not found
Error writing Crisocket information for the control-plane node
```

Then delete conf file
```
sudo rm -rf /usr/lib/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
sudo systemctl daemon-reload && sudo systemctl stop kubelet 
```

When

the Secret does not include the required certificate or key - name: external-etcd.crt, path: /etc/kubernetes/pki/apiserver-etcd-client.crt

Then uploaded-certs append flag `--config kubeadm-config.yaml`
```bash
sudo kubeadm init phase upload-certs --upload-certs --config kubeadm-config.yaml
```


## Link

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/



