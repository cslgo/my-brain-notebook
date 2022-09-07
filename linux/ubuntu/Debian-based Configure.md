Debian-based Linux Configure
===

## 更改源
```shell
root@k8s:~# cp /etc/apt/sources.list /etc/apt/sources.list.bak
root@k8s:~# echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal universe
deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe
deb http://mirrors.aliyun.com/ubuntu/ focal multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-security universe
deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse" > /etc/apt/sources.list
root@k8s:~#
root@k8s:~# apt update && apt upgrade -y
```

Or add to /etc/apt/sources.list 
```bash
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy universe
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy universe
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates universe
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security universe
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-security universe
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-security multiverse
```

## 安装 zsh

```shell
root@k8s:~# apt install zsh
```
## 安装 oh-my-zsh

```shell
root@k8s:~# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 安装 [zsh-users](https://github.com/zsh-users) 插件

## 配置 Systemd

由于默认情况下 WSL 中不能使用 systemd，所以很多应用程序没办法启动，不过还是有一些大神解决了这个问题，我们可以在 https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033 链接下面找到启动 SystemD 的方法。

首先安装 Systemd 相关的依赖应用

    apt install -yqq fontconfig daemonize

然后创建一个如下所示的脚本文件：

```shell
# Create the starting script for SystemD
$ sudo vim /etc/profile.d/00-wsl2-systemd.sh
SYSTEMD_PID=$(ps -ef | grep '/lib/systemd/systemd --system-unit=basic.target$' | grep -v unshare | awk '{print $2}')

if [ -z "$SYSTEMD_PID" ]; then
   sudo /usr/bin/daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
   SYSTEMD_PID=$(ps -ef | grep '/lib/systemd/systemd --system-unit=basic.target$' | grep -v unshare | awk '{print $2}')
fi

if [ -n "$SYSTEMD_PID" ] && [ "$SYSTEMD_PID" != "1" ]; then
    exec sudo /usr/bin/nsenter -t $SYSTEMD_PID -a su - $LOGNAME
fi
```

##
