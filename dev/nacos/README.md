[nacos](https://nacos.io/en-us/index.html)
===


```bash
wget https://github.com/alibaba/nacos/releases/download/2.1.0/nacos-server-2.1.0.tar.gz

tar zxvf nacos-server-2.1.0.tar.gz

cd nacos/bin

sh startup.sh -m standalone

```
nacos cluster conf

```bash
# nacos mysql sql
scp schema.sql root@10.0.0.81:~
scp nacos-mysql.sql root@10.0.0.81:~
ssh 10.0.0.81
mysql -u root -p
mysql> drop database nacos;
mysql> create database nacos;
mysql> create user nacos identified by '!Nacos2Cmdi';
mysql> grant all privileges on nacos.* to 'nacos'@'%';
mysql -u nacos -p
mysql> show grants;
mysql -u nacos -p nacos < ~/nacos-mysql.sql

cp cluster.conf.example cluster.conf
vi cluster.conf
```

```conf
10.0.0.80:8848
10.0.0.81:8848
10.0.0.82:8848
```
nacos cluster nginx conf

```conf
# tcp server
stream {
    upstream nacos-tcp-9848 {
        server  10.0.0.80:9848   weight=1;
        server  10.0.0.81:9848   weight=1;
        server  10.0.0.82:9848   weight=1;
    }
    server {
        listen  9848;
        proxy_pass  nacos-tcp-9848
    }
    upstream nacos-tcp-9849 {
        server  10.0.0.80:9849   weight=1;
        server  10.0.0.81:9849   weight=1;
        server  10.0.0.82:9849   weight=1;
    }
    server {
        listen  9849;
        proxy_pass  nacos-tcp-9849
    }
}
# http server
http {
    upstream nacos-cluster {
        server  10.0.0.80:8848   weight=1;
        server  10.0.0.81:8848   weight=1;
        server  10.0.0.82:8848   weight=1;
    }
    server {
        listen  8848;
        server_name _;
        location    /   {
            proxy_pass  http://nacos-cluster/;
        }
    }
}
```

https://nacos.io/zh-cn/docs/cluster-mode-quick-start.html