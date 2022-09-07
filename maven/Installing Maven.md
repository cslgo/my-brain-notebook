Intalling Maven in Linux
===

## Linux

```bash
# https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.5.4-bin.tar.gz
# https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.6.3-bin.tar.gz
$ wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
```
```bash
$ sudo mkdir /usr/local/maven/
$ sudo tar -zxvf apache-maven-3.8.5-bin.tar.gz -C /usr/local/maven/
$ sudo vim /etc/profile
MAVEN_HOME=/usr/local/maven/apache-maven-3.8.5
export PATH=${MAVEN_HOME}/bin:${PATH}
$ source  /etc/profile
sudo mvn -v
```
