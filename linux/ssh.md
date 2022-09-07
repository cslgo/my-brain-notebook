SSH
===

## 生成 ssh key

ssh-keygen

```bash
yum install -y ssh-keygen  ssh-copy-id
ssh-keygen -t rsa -f ~/.ssh/id_rsa -C "caojiaqing@cmdi.chinamobile.com"
```
* -t: 密钥类型，可选 dsa 、ecdsa 、 ed25519、rsa
* -f: 密钥目录位置， 默认/.ssh/id_rsa
* -C: 指定此密钥的备注信息, 需要配置多个免密登录时, 建议携带
* -N: 指定此密钥对的密码, 如果指定此参数, 则命令执行过程中就不会出现交互确认密码的信息

```shell
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@10.0.0.14
```

## ssh 超时设置

SSH Client会从以下途径获取配置参数:

1. SSH命令行参数
2. 用户配置文件 (~/.ssh/config)
3. 系统配置文件 (/etc/ssh/ssh_config)

```bash
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=30 root@10.0.1.25 -p22
```

```
$ vim ~/.ssh/config #添加如下内容
Host *
 ServerAliveInterval 60
 ServerAliveCountMax 30
# 立即生效
service sshd reload
```

```
$ vim /etc/ssh/ssh_config
# 在Host *下面添加：
Host *
       SendEnv LANG LC_*
       ServerAliveInterval 60
       ServerAliveCountMax 30
```

如果三个都设置了读取顺序是否是姿势1 ---> 姿势2 ---> 姿势3







