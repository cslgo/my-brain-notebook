Debian-based Linux Configure
===
## 安装 VMware Tools 

配置 CD/DVD
Applications/VMware Fusion.app/Contents/Library/isoimages/linux.iso
mv vmware-tools-distrib.tar.gz ~/Documents
```bash
cd ~/Documents
chmod +x vmware-tools-distrib.tar.gz
tar zxvf vmware-tools-distrib.tar.gz
cd vmware-tools-distrib
sudo ./vmware-install.pl
```

macOS安装虚拟机，上述安装后不起作用， 可以考虑使用其一个开源子集实现 open-vm-tools 及 open-vm-tools-desktop，简单省事！

```
sudo apt update && sudo apt upgrade
sudo apt install open-vm-tools
sudo apt install open-vm-tools-desktop
reboot
```

## 更改源

中科大
```bash
sudo mv tee /etc/apt/sources.list tee /etc/apt/sources.list.bak
sudo cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
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
候选

清华源
```bash
sudo cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF
```

阿里源(慢)
```shell
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cat <<EOF | sudo tee /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
EOF
```

更新源
```bash
sudo apt update && sudo apt upgrade -y
```
## 安装 zsh

https://vitux.com/ubuntu-zsh-shell/

```shell
sudo apt update && sudo apt dist-upgrade -y
sudo apt install -y build-essential curl file git
sudo apt install -y zsh
zsh --version
sudo apt install fonts-powerline
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
# First, change the shell for Root:
sudo -s
chsh -s /bin/zsh root
chsh -s /bin/zsh slcho
reboot
```
## 安装 oh-my-zsh

```shell
root@k8s:~# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 安装 [zsh-users](https://github.com/zsh-users) 插件

