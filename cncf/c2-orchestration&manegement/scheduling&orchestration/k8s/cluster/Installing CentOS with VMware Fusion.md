
VMware Fusion Centos Configuration
===

VMNET Static IP Configuration, No Using!!!
```bash
host centos-7-node0 {
        hardware ethernet 00:0C:29:EF:CB:5A;
        fixed-address 10.10.10.20;
}
host centos-7-node1 {
        hardware ethernet 00:0C:29:EF:CB:5B;
        fixed-address 10.10.10.21;
}
host centos-7-node2 {
        hardware ethernet 00:0C:29:EF:CB:5C;
        fixed-address 10.10.10.22;
}
```

## No Internet Connection from VMware with CentOS 7

解决 CentOS 7 安装后无网络的方案

### 方案 1

在虚拟机DHCP网卡生效的情况下会及时生效，可用于安装必要的网络排查工具，如 `net-tools`

```bash
dhclient –v
```

Go to /etc/init.d

一种持续启动生效的方案，这里可以不用关注，后续会考虑配置静态 IP 的方案

Create a file with following, I have kept the name as “net-autostart“

```bash
#!/bin/bash
# Solution for "No Internet Connection from VMware"
#
### BEGIN INIT INFO
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
dhclient -v
```

Save the file and change the file permission as executable

```bash
chmod 755 net-autostart
```

### 方案 2：静态 IP 方案

这里也可以启动 DHCP，可根据需要设定

Enter Vmnet8 directory of VMware Fusion through Mac terminal

```bash
cd /Library/Preferences/VMware\ Fusion/vmnet8
```

查看 `dhcp.confd` 文件，搞清楚网卡子网范围、域名服务器及路由服务器；查看主机网络高级属性 DNS 属性配置，用于配置虚拟机域名服务器DNS1。

Log on to CentOS7

Enter the network-scripts directory of the virtual machine

```bash
cd /etc/sysconfig/network-scripts
```

Find the file at the beginning of ifcfg-en. In the figure above, my file is ifcfg-ens33.

```bash
vi /etc/sysconfig/network-scripts/ifcfg-ens33
```

Under normal circumstances, there is no need to modify anything else, all kinds of ghosts from Baidu.

Using DHCP
```bash
BOOTPROTO=dhcp
NAME=ens33, DEVICE=ens33, this ens33 has the same suffix as the incoming name ifcfg-ens33
ONBOOT=yes
```

Using Static IP
```bash
TYPE=Ethernet
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.10.10.20
GATEWAY=10.10.10.2
NETMASK-255.255.255.0
DNS1=192.168.3.1 
```

After saving, restart the service to make the changes take effect

```bash
service network restart
```

## Change Yum Sources

Backup base source
```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
```

Changeg to Alibaba Cloud selected here

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# OR
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

```bash
# Clear cache
yum clean all
# Generate a new cache
yum makecache
# Update yum
yum update
```

## Reference Link


https://developpaper.com/mac-vmware-fusion-centos7-configuration-of-static-ip-tutorial-diagram/