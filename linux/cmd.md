
# Linux Cmds

## 常用命令
##
```shell
tail -n 5 vhosts.conf
tar -xvfz foo.tar.gz
##creates the archive foo2.zip, containing all the files and directories in the directory foo1 that is contained within the current directory
zip -r foo1 foo2 
```
## 系统
```shell
##查看系统架构
arch
cat /proc/version
##查看内核/操作系统/CPU信息
uname -a
uname -r
##查看操作系统版本
head -n 1 /etc/issue
##查看CPU信息
cat /proc/cpuinfo
# 查看linux版本信息
cat /etc/issue
hostnamectl
lsb_release -a
##查看计算机名
hostname
##列出所有PCI设备
lspci -tv
##列出所有USB设备
lsusb -tv
##列出加载的内核模块
lsmod
##查看环境变量
env
##查看系统时间
date
##查看年日历
cal <yyyy>
```
## 进程
```shell
##实时显示进程状态
top
##查看所有进程的详细信息
ps -ef
##搜索nmon相关的进程
ps -ef | grep nmon
```

## 磁盘和分区
```shell
##mount查看挂接的分区状态
mount | column -t
##查看所有分区
fdisk -l
##查看所有交换分区
swapon -s
##查看磁盘参数(仅适用于IDE设备)
hdparm -i /dev/hda
##查看启动时IDE设备检测状况
dmesg | grep IDE
```
## 网络
```shell
##查看所有网络接口的属性
ifconfig
##查看防火墙设置
sudo iptables -L
##查看路由表
route -n
##查看所有监听端口
netstat -lntp
##查看所有已经建立的连接
netstat -antp
##查看网络统计信息
netstat -s
```
## 用户与组
```shell
##查看活动用户
w
##查看指定用户信息
id <username>
##查看用户登录日志
last
##查看系统所有用户
cut -d: -f1 /etc/passwd
##查看系统所有组
cut -d: -f1 /etc/group
##查看当前用户的计划任务
crontab -l
##Create a new group named group_name
groupadd group_name
##Delete group group_name
groupdel group_name
##Rename group old_group_name in new_group_name
groupmod -n new_group_name old_group_name
##Create user1, assign /home/user1 as its home directory, assign /bin/bash as a shell, include it in ‘admin’ group and add a comment Nome Cognome
useradd -c "Nome Cognome" -g admin -d /home/user1 -s /bin/bash -m user1
##Create user1
useradd user1
##Delete user1 and its home directory
userdel -r user1
##这种会把用户从其他组中去掉，只属于该组
usermod -G groupname username
##把用户添加到这个组，之前所属组不影响
usermod -a -G group_name  user1
## sudoers
usermod -aG wheel username
##Change password
passwd
##Change password of user1 (only root)
passwd user1
sudo chmod u+w /etc/sudoers
sudo vim /etc/sudoers
```


## 文件
```shell
##Add rights 777 (Read Write Execute) to directory1 – full rights to everybody.
chmod 777 directory1
##Add rights to directory1, including all files and subfolders in it, rights 777 (Read Write Execute) - full rights to everybody.
chmod –R 777 directory1
##Assign user1 as the owner of file1
chown user1 file1
##Recursively assign user1 as the owner of directory1
chown -R user1 directory1
##Assign user 'apache' from the group 'apache' to folder 'dir', including all subfolders and files
chown apache:apache -R /var/www/dir
##Find all files in the current directory, including subfolders and assign rights 664
find . -type f -printf "\"%p\" " | xargs chmod 664
##Find all folders in the current directory, including subfolders and assign rights 775
find . -type d -printf "\"%p\" " | xargs chmod 775
##Unarchive file 'file1.bz2'
bunzip2 file1.bz2
##Unarchive file 'file1.gz'
gunzip file1.gz
##Archive file 'file1' to file1.gz
gzip file1
##Archive file file1 to file1.bz2
bzip2 file1
##Create an archive and zip it with gzip
tar -cvfz archive.tar.gz dir1
##Unarchive and extract
tar -xvfz archive.tar.gz
##Create zip-archive
zip file1.zip file1
##Unarchive and extract zip-archive
unzip file1.zip
##Unarchive jar file
jar -xvf xxx.jar
```
## 服务
```shell
##列出所有系统服务
chkconfig --list
##列出所有启动的系统服务
chkconfig --list | grep on
```
## 查找
```shell
find / -name file1
find / -user user1
find /var/www -name "*.log"
##Find all files containing '.png' in the name. it is recommended to run 'updatedb' command before this.
locate "*.png"
##Find all files with '.log' extension in the current directory, including subdirectories and delete them
find . -name '*.log' -type f -delete
```

## 系统资源

### free 查看内存使用统计信息
```shell
#以MB为单位显示
free -m
```
### df 查看各分区使用情况
```shell
df -h 
```
### du 查看指定目录的大小
```shell
du -sh <目录名> 
```
### top 比较全面的看cpu负载、内存、虚拟内存使用状况
### htop 可视化显示CPU的使用状况的工具
### uptime 查看系统运行时间、用户数、负载
### proc 信息查看
```shell
#查看内存总量
grep MemTotal /proc/meminfo
#查看空闲内存量
grep MemFree /proc/meminfo 
#查看系统负载
cat /proc/loadavg
```
### mpstat 查看每个CPU的负载信息
```shell
# 5秒刷新一下，可以被top后按1代替，不过线程特别多显示不了的，可以用这个。ALL换成数字，表示只看此cpu线程：
mpstat -P ALL 5
```
### vmstat 虚拟内存的使用信息
```shell
#每隔10秒查看
vmstat 10
```
### iostat 磁盘IO的统计信息
```shell
#每隔5秒查看
iostat -xkdz 5
```
### dstat 类似vmstat的显示优化的工具
```shell
#600秒换一行，每秒刷新
dstat 600
```
### pidstat 进程资源使用信息查看
```shell
#占用率
pidstat 10
#每秒读写情况
pidstat -d 10
```
### netstat 网络连接状态查看
```shell
#查看所有监听端口
netstat -lntp
#查看所有已经建立的连接
netstat -antp
#查看网络统计信息
netstat -s
```
### strace 查看某个进程的系统资源调用情况
```shell
#-p后面是pid，-tttT 进程系统后的系统调用时间：
strace -tttT -p 12670
#统计IO设备输入输出的系统调用信息
strace -c dd if=/dev/zero of=/dev/null bs=512 count=1024k
```

### tcpdump 查看网络数据包
```shell
tcpdump -nr /opt/tmpfiles/tcpdump.out
```

### btrace 块设备的读写事件信息统计
```shell
btrace /dev/sdc
```

### iotop 查看某个进程的IO操作统计信息
```shell
yum install -y iotop
iotop -bod5
```
### slabtop查看内核、内存分配器的使用信息
```shell
slabtop -sc
```
### 系统参数生效
```shell
vim /etc/sysctl.conf
sysctl -a
```
### 系统cpu活动状态查看
```shell
perf record -a -g -F 997 sleep 10
```
## 前后台操作

### 1. shell 操作之前任务的前后调用
```shell
Ctrl-z              #將当前任务暂停到后台
$ bg %JOBNUM        #将任务调到后台运行
$ fg %JOBNUM        #将任务调到前台运行
$ jobs              #查看后台的任务
$ kill              #终止后台的任务
```

### 2. 将命令或脚本放到后台运行
```shell
 $ COMMAND &
 $ ./SHELL.sh &
 #不过，运行的结果还是会输出到屏幕上，所以最好加上输出重定向，如下：
 $ COMMAND &> /dev/null &
```

### 3. 退出当前 shell 时，保持后台任务继续运行
```shell
$ nohup COMMAND &
$ nohup ./SHELL.sh &
# 或者使用 setsid 将其父进程设为init进程(进程号为1)
$ setsid COMMAND.sh &
#对于已经在后台运行的进程，可以使用 disown 命令
$ ./test.sh &
$ jobs -l
$ disown -h %JOBNUM
```