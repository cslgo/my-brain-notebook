Ubuntu Desktop
===

## 更新源

[参考](Debian-based%20Configure.md)

## 更新 Ubuntu

```bash
sudo apt update && sudo apt upgrade -y
```

## 安装SSH(OpenSSH)

最新的Ubuntu 22.04 LTS系统默认没有安装和启用SSH服务，因此首先在终端中运行以下命令，执行安装操作

```bash
sudo apt install openssh-server -y
```

安装完后，使用systemctl启动SSH服务

```bash
sudo systemctl enable --now ssh
sudo systemctl status ssh
```

另一个方便检查连接状态的命令如下

```bash
sudo ss -lt
```

### 检查防火墙状态

在进行远程连接前，检查系统防火墙的状态，当前我安装的Ubuntu 22.04 LTS Jammy Jellyfish Desktop防火墙处于未激活状态

```bash
sudo ufw status
```

### 关闭SSH (OpenSSH)服务

```bash
sudo systemctl disable ssh --now

```

### 如果想彻底删除SSH服务，使用如下命令

```bash
sudo apt autoremove openssh-server -y
```

