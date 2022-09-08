wsl 查看

    wsl -l -v
    
    wsl.exe --list --verbose

设置 Linux 发行版的 WSL 版本

    wsl --set-version <distribution name> <versionNumber>

Linux 默认启用 WSL 版本

    wsl --set-default-version 2

关闭

    wsl --shutdown

重启

    Get-Service LxssManager | Restart-Service
    # or
    wsl

设置Ubuntu默认用户为root

    ubuntu config --default-user root



[Build a kernel with xt_recent kernel module enabled](https://kind.sigs.k8s.io/docs/user/using-wsl2/#kubernetes-service-with-session-affinity)


```shell
docker run --name wsl-kernel-builder --rm -it ubuntu:latest bash

WSL_COMMIT_REF=linux-msft-5.4.72 # change this line to the version you want to build

# Install dependencies
apt update
apt install -y git build-essential flex bison libssl-dev libelf-dev bc

# Checkout WSL2 Kernel repo
mkdir src
cd src
git init
git remote add origin https://github.com/microsoft/WSL2-Linux-Kernel.git
git config --local gc.auto 0
git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin +${WSL_COMMIT_REF}:refs/remotes/origin/build/linux-msft-wsl-5.4.y
git checkout --progress --force -B build/linux-msft-wsl-5.4.y refs/remotes/origin/build/linux-msft-wsl-5.4.y

# Enable xt_recent kernel module
sed -i 's/# CONFIG_NETFILTER_XT_MATCH_RECENT is not set/CONFIG_NETFILTER_XT_MATCH_RECENT=y/' Microsoft/config-wsl

# Compile the kernel 
make -j2 KCONFIG_CONFIG=Microsoft/config-wsl

# From the host terminal copy the newly built kernel
docker cp wsl-kernel-builder:/src/arch/x86/boot/bzImage .
```

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