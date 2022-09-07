5.7 Installing
===

On CentOS
```bash
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm -Uvh mysql57-community-release-el7-11.noarch.rpm 
yum repolist all | grep mysql
yum install -y mysql-community-server
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
systemctl start mysqld
grep 'temporary password' /var/log/mysqld.log
mysql -u root -p -h 10.0.0.81

\c
```

Set default charset utf8 `vi /etc/my.conf`
```bash
character_set_server=utf8
systemctl restart mysqld
```

You must reset your password using ALTER USER statement before executing this statement.
```bash
mysql> ALTER USER USER() IDENTIFIED BY '!SqywYc4NsM4';
mysql> SHOW DATABASES;
```

How to Fix ERROR 1130 (HY000): Host is not allowed to connect to this MySQL server

```bash
mysql -u root -p
mysql> drop database vrms_topo;
mysql> create database vrms_topo;
mysql> CREATE USER vrms IDENTIFIED BY '!Topo1Vrms';
mysql> SELECT host, user FROM mysql.user;
mysql> grant all privileges on vrms_topo.* to 'vrms'@'%';
mysql -u vrms -p
mysql> show grants;
+-----------------------------------------------------+
| Grants for vrms@%                                   |
+-----------------------------------------------------+
| GRANT USAGE ON *.* TO 'vrms'@'%'                    |
| GRANT ALL PRIVILEGES ON `vrms_topo`.* TO 'vrms'@'%' |
+-----------------------------------------------------+
```

Import sql file into database
```bash
 mysql -u vrms -p vrms_topo < ~/sysmgr_topo.sql 
```
Export
```bash
mysqldump -u vrms -p vrms_topo > ~/sysmgr_topo_bak.sql 
```

If the above command fails with a password-does-not-meet-requirements error, uninstall the MySQL password_validate plugin or pick a more complex password 
```bash
mysql -u root -p -e "uninstall plugin validate_password;"
```


https://blog.csdn.net/qq_51625007/article/details/126041055
