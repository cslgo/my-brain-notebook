Ubuntu Commands
===
## 

```bash
## 系统安装后初始化 root 密码
sudo passwd
sudo apt update && apt upgrade
sudo hostnamectl set-hostname <hostname>
sudo shutdown -r
## 解决 sudo 命名反应延时问题
echo 127.0.0.1 `hostname` `hostname`.localdomain | sudo tee -a /etc/hosts && cat /etc/hosts
## 解决 ssh 连接失败问题
sudo vim /etc/ssh/sshd_config
## append PermitRootLogin yes
sudo systemctl restart sshd

```

## [AptGet](https://help.ubuntu.com/community/AptGet/Howto)
```bash
## List All Repositories
apt-cache policy

## List All Packages
apt-cache pkgnames

## List Installed Packages
apt list --installed

## Install Package
sudo apt-get install <package-name>

## Remove Package
sudo apt-get remove <package-name>

## Remove Package and Configuration
sudo apt-get --purge remove <package-name>

## Remove Orphen Packages
sudo apt-get --purge autoremove

## Check for Updates
## The following command will update the list of available packages and their versions, but it does not install or upgrade any packages. The “update” command should be run before the “upgrade” command.
sudo apt-get update

## Upgrade All Packages
## The following command will upgrade installed packages. The “update” command should be run before the “upgrade” command.
sudo apt-get upgrade

## View Package Information
apt show <package>

```