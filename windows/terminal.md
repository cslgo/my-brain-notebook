## Windows

## 安装 WSL2


[wsl](https://docs.microsoft.com/en-us/windows/wsl/)

Reference:

https://cloud.tencent.com/developer/article/1795069

https://zhuanlan.zhihu.com/p/224753478


### 如何安装WSL&WSL2

必须先启用“适用于 Linux 的 Windows 子系统”可选功能，然后才能在 Windows 上安装 Linux 分发版。 以管理员身份打开 PowerShell 并运行：

```shell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

如果仅仅只安装 WSL 1，完成此步骤并重启计算机后安装所选的 Linux 分发版就可以了，如果需要WSL2还需要进行后续步骤。

### 更新到 WSL2

WSL2 是对基础体系结构的一次重大改造，它使用虚拟化技术和 Linux 内核来实现其新功能。WSL2拥有更加完整的Linux体验。只有 Windows 10 版本 2004 的内部版本 19041 或更高版本中才提供 WSL2。如果需要 WSL2，必须使用2004(内部版本 19041)或更高版本的Windows 10才能支持。

启用“虚拟机平台”可选组件

安装 WSL2 之前，必须启用“虚拟机平台”可选功能。 以管理员身份打开 PowerShell 并运行:

```shell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

重新启动计算机，以完成 WSL 安装并更新到 WSL2

### 安装所选的 Linux 分发版

打开 Microsoft Store，并选择你偏好的 Linux 分发版。这里以Ubuntu 20.04 LTS为例

首次启动WSL设置

首次启动需要设置用户名

设置root密码

```shell
sudo passwd root
```

输入“su”来切换到root用户，当看到“$”变为“#”说明用户切换成功

### 将分发版本设置为 WSL 1 或 WSL2

可以打开 PowerShell 命令行并输入以下命令检查分配给每个已安装的 Linux 分发版的 WSL 版本：

```shell
wsl -l -v

wsl --list --running
```

若要将分发版设置为受某一WSL 版本支持，请运行

```shell
wsl --set-version <distribution name> <versionNumber>
```

其中:为你的分发版的实际名称如Ubuntu-20.04； 为“1”或“2”，你可以随时更改回 WSL 1，方法是运行与上面相同的命令

## WSL2 的使用

WSL2 的使用方式与Linux别无二致，你可以很方便的在 WSL2中使用Linux的各种命令。但是需要注意的是，WSL中的文件都默认是777权限，这点可能与真实Linux环境不同，某些在WSL中运行正常的程序或者命令，在真实Linux中可能因权限问题而运行失败。 接下来将介绍几个 WSL2 的使用场景。

### Docker Desktop

WSL2 推出后 Docker 立即跟进推出了支持 WSL2 的版本。在没有 WSL2 之前Docker Desktop一直被人诟病.bug多、改了配置不生效，响应慢等问题不胜枚举。而以上这些问题在WSL2推出后都有所改善（至少我还没有遇到过以上问题）。

先决条件： 1. 安装Windows 10 2004版或更高版本 2. 已开启WSL2 功能

1. 按照正常安装步骤安装Docker Desktop，如果系统支持WSL2，Docker Desktop在安装过程中会提示开启WSL2
2. 安装完成后运行Docker Desktop，选择Setting>General

* 勾选Use WSL2 based engine
* 点击Apply & Restart
* 当Docker Desktop重启完成后,依次点击Settings > Resources > WSL Integration 勾选Enable integration with my default WSL distro在默认WSL2分发上启用WSL集成,并选择需要开启的WSL2分发版,图中只有一个Ubuntu-20.04

WSL Docker: System.InvalidOperationException: Failed to set version to docker-desktop exit code: -1

问题原因：
代理软件（VPN）和wsl2的sock端口冲突

Proxifer 开发者解释如下：

```
如果Winsock LSP
DLL被加载到其进程中，则wsl.exe将显示此错误。最简单的解决方案是对wsl.exe使用WSCSetApplicationCategory
WinAPI调用来防止这种情况。在后台，该调用在HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\AppId_Catalog中为wsl.exe创建一个条目。
这将告诉Windows不要将LSP DLL加载到wsl.exe进程中
```

解决方法:
1、临时方案：管理员身份运行CMD使用`netsh winsock reset`命令重置修复。然后重启电脑(很方便，但这个问题还是会不时出现）

2、长期解决方案：

1) 使用NoLsp.exe，[下载链接](http://www.proxifier.com/tmp/Test20200228/NoLsp.exe)，需要梯子,[网盘链接](https://pan.baidu.com/s/19qXGW_0FMiKWQp3IhrmA2w)，提取码：b6st
2) 管理员身份运行CMD，输入:
```shell
NoLsp.exe C:\windows\system32\wsl.exe
```

ln -s /mnt/d/data /opt/data


### wsl 文件权限问题

挂载文件权限,子系统可以直接访问windows下的任何文件，这也是比虚拟机好用的关键点之一。在 /mnt 目录下就可以访问c、d、e、f等盘符，并且可以直接访问任何一个文件位置。因为windows的盘符挂载到linux中的时候全部都用了 777 的权限，在一些软件开发上可能会出现一些问题。

解决方法:使用wsl的自动挂载功能，修改 /etc/wsl.conf 文件（没有就创建一个）,修改内容为

```shell
[automount]
enabled = true
root = /mnt/
options = "metadata,dmask=022,fmask=133"
mountFsTab = true
```
就可以将/mnt下的所有盘都挂载为linux下默认的权限 wsl.conf还可以配置其他选项[点击查看](https://devblogs.microsoft.com/commandline/automatically-configuring-wsl/)

windows wsl 创建文件权限

挂载问题是解决了,但是使用wsl命令打开的终端创建新的文件还是 777

解决方法

    在/etc/profile或~/.profile或~/.bashrc最后添加一些逻辑。

```
if [[ "$(umask)" == '000' ]]; then
    umask 022
fi
```

这样在每次启动终端的时候就会重新设置umask, 之后创建文件就正常了

vscode Remote-wsl插件创建目录权限


remote-wsl是一个可以用windows的vscode编辑wsl项目的插件。配置好后编码非常方便。可以在windows直接编辑并运行linux子系统中的代码。
  Remote-wsl其实是在linux中安装了一个vscode的服务，也就是后来在 win 上使用的vscode，其实是运行在wsl里的，而 win 只提供前端展示和操作。
  具体安装方法可以百度。这里解决vscode创建linux目录或者文件权限问题。
解决过wsl文件创建权限问题后，vscode中无论是下侧终端，还是左侧目录。创建文件和目录依然有权限问题(777)。
解决方法

```
echo umask 022 >> ~/.vscode-server/server-env-setup
或者(取决于安装vscode的版本)
echo umask 022 >> ~/.vscode-server-insiders/server-env-setup
```

这个文件默认是没有的，功能是可以配置一些linux的vscode-server的一些启动环境，可将umask调整为linux默认值。


https://github.com/deanbot/easy-wsl-oh-my-zsh-p10k

## wsl 启动 [已退出进程，代码为 4294967295] 解决办法

win10 重启后,启动wsl子系统时,出现这个错误 -- [已退出进程，代码为 4294967295], 问题具体原因不太一样,不过如下解决办法 对我有效.

解决办法:

执行命令
```shell
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
```

重启 windows

执行 开启命令

```shell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

再重启 windows


```
 bcdedit /set hypervisorlaunchtype off
 bcdedit /set hypervisorlaunchtype auto
 ```