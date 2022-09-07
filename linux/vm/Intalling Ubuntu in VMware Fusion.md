Intalling Ubuntu in VMware Fusion
===

Mac 系统安装 Ubuntu Server 配置环境

```
OS：macOS Monterey 版本 12.3
VM：VMware-Fusion-12.2.3-19436697_x86.dmg
Mirror：ubuntu-22.04-server-amd64.iso
```

## 安装

1. 选择安装方法 -> 从光盘或映像中安装 -> 继续
2. 创建新的虚拟机 -> 使用其它光盘或光盘映像 -> 选择本地 iso 镜像 -> 继续
3. 选择固件类型 -> 传统 BIOS -> 继续
4. 完成 -> 自定义配置 ->
   1. 存储为：虚拟存储名称
   2. 标签：可选
   3. 位置：自定义存储位置 -> 存储
5. 配置 -> 可选配置 ->
   1. 处理器与内存：选择合适的处理器核数与内存大小
   2. 显示器：若是安装服务网，可将显示相关开关关闭
   3. 内存： 设置合适的内存大小
   4. 移除不必要的设备：比如摄像头 打印机 声卡
   5. 高级：选中`停用侧通道缓解` -> 关闭
6. 启动
7. 选择 -> 回车
8. 语言选择 -> Done
9. 键盘选择 -> Done
10. 安装选择：Ubuntu Server  -> Done
11. 网络链接，DHCPv4 自动分配 -> Done
12. 代理地址：空 -> Done
13. 镜像地址：可填 http://mirrors.ustc.edu.cn/ubuntu/ -> Done
14. 使用整个磁盘： -> Done
15. 文件系统总结： -> Done -> Continue
16. 用户信息：用户名 服务器名称 昵称 密码设置 -> Done
17. 是否安装OpenSSH：回车 选择 -> Done
18. 可选功能安装：空 -> Done
19. Reboot Now

安装完毕！

虚拟机共享主机VPN方法：

1. 设置静态IP
2. 设置虚拟机子网与主机 VPN IP 同一网段
3. 把 VPN IP 设置为虚拟机网关 IP

```bash
❯ sudo /Applications/VMware\ Fusion.app/Contents/Library/                     10:17:18
Create\ Mavericks\ Installer.tool*       mksSandbox-stats*                        vmnet-netifup*
Create\ macOS\ Installer.tool*           ntfscat*                                 vmnet-sniffer*
Deploy\ VMware\ Fusion.mpkg/             ntfscp*                                  vmrest*
Initialize\ VMware\ Fusion.tool*         ntfsls*                                  vmrun*
LaunchServices/                          ntfsresize*                              vmss2core*
QuickLook/                               regval*                                  vmware-aewp*
VMware\ Fusion\ Applications\ Menu.app/  relaunch.sh*                             vmware-authd*
VMware\ Fusion\ Problem\ Reporter.tool*  roms/                                    vmware-cloneBootCamp*
VMware\ Fusion\ Start\ Menu.app/         scriptreg*                               vmware-id*
VMware\ OVF\ Tool/                       services/                                vmware-ntfs*
amsrv*                                   shares/                                  vmware-rawdiskAuthTool*
dockers/                                 thnuclnt/                                vmware-rawdiskCreator*
icu/                                     tools-upgraders/                         vmware-remotemks*
isoimages/                               tpm2emu*                                 vmware-usbarbitrator*
kexts/                                   unrar*                                   vmware-vdiskmanager*
languageSpecificMacToWinKeymap/          virtualprinter/                          vmware-vmdkserver*
licenses/                                vkd/                                     vmware-vmx*
messages/                                vmnet-bridge*                            vmware-vmx-debug*
mkisofs*                                 vmnet-cfgcli*                            vmware-vmx-stats*
mkntfs*                                  vmnet-cli*                               vnckeymap/
mksSandbox*                              vmnet-dhcpd*
mksSandbox-debug*                        vmnet-natd*

❯ sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
Password:
Stopped DHCP service on vmnet1
Stopped DHCP service on vmnet8
Stopped NAT service on vmnet8
Stopped all configured services on all networks
❯ sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
Enabled hostonly virtual adapter on vmnet1
Started DHCP service on vmnet1
Failed to start NAT service on vmnet4
Enabled hostonly virtual adapter on vmnet4
Failed to start DHCP service on vmnet4
Started NAT service on vmnet8
Enabled hostonly virtual adapter on vmnet8
Started DHCP service on vmnet8
Failed to start some/all services
❯ sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --status

```


### Ubuntu 镜像源配置：

https://launchpad.net/ubuntu/+archivemirrors

比如可选：`http://mirrors.ustc.edu.cn/ubuntu/`

## 虚拟网络配置

VMware Fusion 安装后会自动生成 vmnet1、vmnet8 2个虚拟网卡

```shell
❯ cd /Library/Preferences/VMware\ Fusion
❯ ll
total 40
-r--r--r--  1 root  wheel    31B  5  2 19:47 lastLocationUsed
-rw-r--r--  1 root  wheel   556B 12 28 11:27 license-fusion-120-e2-202001
-rw-r--r--  1 root  wheel   548B  4 29 10:57 license-fusion-120-e3-202001
-rw-r--r--  1 root  wheel   643B  5  2 19:49 networking
-rw-r--r--  1 root  wheel   919B  5  2 19:49 networking.bak.0
-rw-r--r--  1 root  wheel     0B  5  2 18:30 promiscAuthorized
drwxr-xr-x  4 root  wheel   128B 12 28 19:23 vmnet1
drwxr-xr-x  7 root  wheel   224B 12 28 19:23 vmnet8
```

其中 vmnet1 为 Host-Only 模式，vmnet8 为 NAT 模式。


### NAT 设置

这里对 vmnet8 进行修改，设置 DHCP yes， 将 SUBNET 修改为自己想用的网段。

```shell
# 修改 VNET_1_DHCP yes ，VNET_1_HOSTONLY_SUBNET 
❯ sudo vim networking
answer VNET_8_DHCP yes
answer VNET_8_HOSTONLY_NETMASK 255.255.255.0
answer VNET_8_HOSTONLY_SUBNET 10.10.10.0
```

修改 vmnet8/nat.conf

```shell
❯ sudo vim vmnet8/nat.conf
# NAT gateway address
ip = 10.10.10.2
netmask = 255.255.255.0
```

### 静态IP配置

查找虚拟机 MAC 地址

```shell
❯ cd ~/Virtual\ Machines.localized/
❯ ll
total 0
drwxr-xr-x@ 38 chosl  staff   1.2K  5  6 16:58 ubuntu-server-node0.vmwarevm
drwxr-xr-x@ 34 chosl  staff   1.1K  5  6 16:56 ubuntu-server-node1.vmwarevm
❯ cat ubuntu-server-node0.vmwarevm/ubuntu-server-node0.vmx | grep ethernet
ethernet0.connectionType = "nat"
ethernet0.addressType = "generated"
ethernet0.virtualDev = "e1000"
ethernet0.linkStatePropagation.enable = "TRUE"
ethernet0.present = "TRUE"
ethernet0.pciSlotNumber = "33"
ethernet0.generatedAddress = "00:0c:29:1b:53:d8"
ethernet0.generatedAddressOffset = "0"
```

添加静态 IP 到 vmnet8 dhcpd.conf
```shell
❯ cd /Library/Preferences/VMware\ Fusion/vmnet8
❯ sudo vim dhcpd.conf
####### VMNET DHCP Configuration. End of "DO NOT MODIFY SECTION" #######
host ubuntu-desktop {
        hardware ethernet 00:0C:29:4D:26:3A;
        fixed-address 10.10.10.126;
}
host ubuntu-server-node0 {
        hardware ethernet 00:0c:29:1b:53:d8;
        fixed-address 10.10.10.10;
        option routers 10.10.10.126;
}
host ubuntu-server-node1 {
        hardware ethernet 00:0c:29:8a:ff:ae;
        fixed-address 10.10.10.11;
        option routers 10.10.10.126;
}
host ubuntu-server-node2 {
        hardware ethernet 00:0c:29:f3:37:42;
        fixed-address 10.10.10.12;
        option routers 10.10.10.126;
}
host ubuntu-server-node3 {
        hardware ethernet 00:0c:29:b7:1c:a1;
        fixed-address 10.10.10.13;
        option routers 10.10.10.126;
}
host ubuntu-server-node4 {
        hardware ethernet 00:0c:29:1c:58:97;
        fixed-address 10.10.10.14;
        option routers 10.10.10.126;
}
host ubuntu-server-node5 {
        hardware ethernet 00:0c:29:85:1f:b6;
        fixed-address 10.10.10.15;
        option routers 10.10.10.126;
}
```

注意！这里 `fixed-address` 范围参考：

```
❯ cat dhcpd.conf | grep range
	range 10.10.10.10 10.10.10.254;
```

## 参考：

https://gist.github.com/pjkelly/1068716/921c8b62ca07e29a7312e81e7b2efa88b69858ab

