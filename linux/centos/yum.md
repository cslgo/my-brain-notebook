yum using
===

## 命令

```bash

yum search <keyword>

# 仅安装指定的软件
yum install <package_name>

# 列出所有可更新的软件清单
yum check-update

# 安装所有更新软件，升级所有包同时也升级软件和系统内核
yum update

# 仅更新指定的软件
yum update <package_name>

# 只升级所有包，不升级软件和系统内核
yum upgrade

yum remove <package_name>

yum list

yum list updates

# 列出所有已安装的软件包
yum list installed

# 列出所有已安装但不在 Yum Repository 內的软件包
yum list extras

# 列出所指定的软件包
yum list <package_name>

# 列出所有软件包的信息
yum info
yum info <package_name>

# 列出所有可更新的软件包信息
yum info updates

# 列出所有已安裝的软件包信息
yum info installed

# 列出所有已安裝但不在 Yum Repository 內的软件包信息
yum info extras

# 列出软件包提供哪些文件
yum provides <package_name>

# 清除缓存目录(/var/cache/yum)下的软件包
yum clean packages

# 清除缓存目录(/var/cache/yum)下的 headers
yum clean headers
```


## 使用 yum update 更新系统时不升级内核，只更新软件包

由于系统与硬件的兼容性问题，有可能升级内核后导致服务器不能正常启动，没有特别的需要，建议不要随意升级内核

```bash
cp /etc/yum.conf    /etc/yum.confbak
```

1. 修改 yum 配置文件 `vi /etc/yum.conf`  在 [main] 的最后添加 exclude=kernel*

2. 直接在 yum 的命令后面加上如下的参数： `yum --exclude=kernel* update`

