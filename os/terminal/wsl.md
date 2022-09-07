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