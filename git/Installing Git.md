Intalling Git
===

## Linux

1. uninstall old verion

```bash
sudo yum remove git
```

2. Installing with source code
```bash
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.gz --no-check-certificate
mkdir /usr/local/git/
tar -zxvf git-2.36.1.tar.gz -C /usr/src
cd /usr/src/git-2.36.1
./configure --prefix=/usr/local/git
```

这里可能提示 gcc 编译器缺失，可以 `yum install -y gcc` 即可

```bash
make prefix=/usr/local/git
```
这里可能包缺少提示，安装如下工具
```bash
yum -y groupinstall "Development Tools" 
yum -y install libcurl-devel curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-CPAN perl-devel
```

继续即可
```bash
make install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
source /etc/profile
git --version
```

重新安装

```bash
rm -rf /usr/local/git /usr/local/git/bin/git
cd /usr/src/git-2.36.1
./configure --prefix=/usr/local/git
make prefix=/usr/local/git
make install
```
