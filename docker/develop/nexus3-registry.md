nexus3-registry
===

## 
```bash

docker-compose -f ./nexus3-registry.yaml up -d
```

## 本地私仓

```bash
docker image ls
docker tag caojiaqing/ingress-nginx.kube-webhook-certgen:v1.1.1 127.0.0.1:5000/ingress-nginx.kube-webhook-certgen:v1.1.1
docker push 127.0.0.1:5000/ingress-nginx.kube-webhook-certgen:v1.1.1
curl 127.0.0.1:5000/v2/_catalog
```

### 配置非 https 仓库地址

Docker 默认不允许非 HTTPS 方式推送镜像

对于使用 systemd 的系统，请在 /etc/docker/daemon.json 中写入如下内容（如果文件不存在请新建该文件
```bash
{
  "registry-mirror": [
    "https://docker.mirrors.ustc.edu.cn/"
  ],
  "insecure-registries": [
    "192.168.199.100:5000"
  ]
}
```

## 私有仓库高级配置

使用 Docker Compose 搭建一个拥有权限认证、TLS 的私有仓库。

### 站点证书

```bash
# 1. 创建 CA 私钥
❯ openssl genrsa -out "root-ca.key" 4096

# 2. 利用私钥创建 CA 根证书请求文件
❯ openssl req \
          -new -key "root-ca.key" \
          -out "root-ca.csr" -sha256 \
          -subj '/C=CN/ST=Beijing/L=Beijing/O=SL Cho/CN=SL Cho Docker Registry CA'
# 以上命令中 -subj 参数里的 /C 表示国家，如 CN；/ST 表示省；/L 表示城市或者地区；/O 表示组织名；/CN 通用名称。

# 3. 配置 CA 根证书，新建 root-ca.cnf

[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash

# 4. 第四步签发根证书

❯ openssl x509 -req  -days 3650  -in "root-ca.csr" \
               -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
               -extfile "root-ca.cnf" -extensions \
               root_ca
Signature ok
subject=/C=CN/ST=Beijing/L=Beijing/O=Your Company Name/CN=Your Company Name Docker Registry CA
Getting Private key

# 5. 生成站点 SSL 私钥
❯ openssl genrsa -out "slcho.docker.com.key" 4096

# 6. 使用私钥生成证书请求文件

❯ openssl req -new -key "slcho.docker.com.key" -out "site.csr" -sha256 \
          -subj '/C=CN/ST=Beijing/L=Beijing/O=SL Cho/CN=slcho.docker.com'

# 7. 配置证书，新建 site.cnf 文件

[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:slcho.docker.com, IP:127.0.0.1
subjectKeyIdentifier=hash

# 8. 签署站点 SSL 证书

❯ openssl x509 -req -days 750 -in "site.csr" -sha256 \
    -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial \
    -out "slcho.docker.com.crt" -extfile "site.cnf" -extensions server
```

这样已经拥有了 `slcho.docker.com` 的网站 SSL 私钥 `slcho.docker.com.key` 和 SSL 证书 slcho.docker.com.crt 及 CA 根证书 `root-ca.crt`。

新建 ssl 文件夹并将 `slcho.docker.com.key` `slcho.docker.com.crt` `root-ca.crt` 这三个文件移入，删除其他文件。

新建 registry 挂载目录 ，一并 将 ssl  auth 目录及 config.yml 一并移到此目录 


```bash

❯ mkdir -p registry/ssl
❯ mv config.yml registry
❯ mv root-ca.crt registry/ssl
❯ mv slcho.docker.com.crt registry/ssl
❯ mv slcho.docker.com.key registry/ssl
```

## 配置私有仓库

私有仓库默认的配置文件位于 /etc/docker/registry/config.yml，我们先在本地编辑 config.yml，之后挂载到容器中。

```yaml
version: 0.1
log:
  accesslog:
    disabled: true
  level: debug
  formatter: text
  fields:
    service: registry
    environment: staging
storage:
  delete:
    enabled: true
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/docker/registry/auth/nginx.htpasswd
http:
  addr: :443
  host: https://slcho.docker.com
  headers:
    X-Content-Type-Options: [nosniff]
  http2:
    disabled: false
  tls:
    certificate: /etc/docker/registry/ssl/slcho.docker.com.crt
    key: /etc/docker/registry/ssl/slcho.docker.com.key
health:
  storagedriver:
    enabled: true
    interval: 10s
threshold: 3
```

## 生成 https 认证文件

```bash
❯ mkdir auth

❯ docker run --rm \
    --entrypoint htpasswd \
    httpd:alpine \
    -Bbn slcho 1a2s3dqwe > registry/auth/nginx.htpasswd
```

将上面的 slcho 1a2s3dqwe 替换为你自己的用户名和密码。


## 编码 docker-compose yaml

```yaml
version: '3'

services:
  registry:
    image: registry
    ports:
      - "443:443"
    volumes:
      - ./registry:/etc/docker/registry
      - registry-data:/var/lib/registry

volumes:
  registry-data:
```

## 修改 hosts

```
127.0.0.1 slcho.docker.com
```

## 测试

由于自行签发的 CA 根证书不被系统信任，所以我们需要将 CA 根证书 registry/ssl/root-ca.crt 移入 /etc/docker/certs.d/slcho.docker.com 文件夹中。

```bash
$ sudo mkdir -p /etc/docker/certs.d/slcho.docker.com

$ sudo cp registry/ssl/root-ca.crt /etc/docker/certs.d/slcho.docker.com/ca.crt
```

macos

```bash
❯ mkdir -p ~/.docker/certs.d/slcho.docker.com

❯ cp registry/ssl/root-ca.crt ~/.docker/certs.d/slcho.docker.com/ca.crt
```

登入到私有仓库

```bash
service docker restarts
```

```bash
❯ docker login slcho.docker.com
```
// TODO ?
Error response from daemon: login attempt to http://slcho.docker.com/v2/ failed with status: 502 Bad Gateway

