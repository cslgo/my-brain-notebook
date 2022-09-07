Ingress
===


## TLS 

```
sudo mkdir ~/ingress/tls
cd ~/ingress/tls
sudo cp /etc/kubernetes/pki/ca.* ./
sudo chown -R slcho:slcho ./*

sopenssl genrsa -out ingress.k8s.local.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=K8s/OU=Personal/CN=ingress.k8s.local" \
    -key ingress.k8s.local.key \
    -out ingress.k8s.local.csr

cat <<-EOF | tee v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=ingress.k8s.local
DNS.2=centos-node3
DNS.3=centos-node4
DNS.4=centos-node5
DNS.4=centos-node0
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in ingress.k8s.local.csr \
    -out ingress.k8s.local.crt
```