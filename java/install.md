openjdk installation
===


## centos 7

```bash
yum update && yum list | grep openjdk
# jre 安装
yum install -y java-1.8.0-openjdk
# jdk 安装
yum install -y java-1.8.0-openjdk-devel-1.8.0.332.b09
```

```bash
vim /etc/profile
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.332.b09-1.el7_9.x86_64
export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```