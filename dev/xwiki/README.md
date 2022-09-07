xwiki installing
===


```bash
wget https://nexus.xwiki.org/nexus/content/groups/public/org/xwiki/platform/xwiki-platform-distribution-war/13.10.8/xwiki-platform-distribution-war-13.10.8.war --no-check-certificate
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.23/bin/apache-tomcat-10.0.23.tar.gz --no-check-certificate
```

MySQL 5.7 or greater.

```bash
# Create the wiki database. You can use the name you want for the database, but you will have to set the hibernate configuration file and xwiki.cfg file accordingly.
mysql -u root -p -e "create database xwiki default character set utf8mb4 collate utf8mb4_bin"
# Create the xwiki user with password xwiki
mysql -u root -p -e "CREATE USER 'xwiki'@'%' IDENTIFIED BY 'Xwiki1@Cmdi'";
mysql -u root -p -e "DROP USER 'xwiki'@'%'";
# Give privileges to the xwiki user for accessing and creating databases (for the multi wiki support). Specifically the xwiki users needs permissions to be able to execute CREATE DATABASE, DROP SCHEMA, and then all CRUD operations on tables. Note that the command below should be tuned to be more restrictive as granting all permissions is not required:
mysql -u root -p -e "grant all privileges on xwiki.* to 'xwiki'@'%'"

```

add mysql-connect-driver

hibernate datasource config

tomcat configuration

xwiki configuration

start tomcat
```conf
CATALINA_BASE=$CATALINA_HOME
./bin/jsvc     \
    -classpath $CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar     \
    -outfile $CATALINA_BASE/logs/catalina.out     \
    -errfile $CATALINA_BASE/logs/catalina.err     \
    -Dcatalina.home=$CATALINA_HOME     \
    -Dcatalina.base=$CATALINA_BASE     \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager     \
    -Djava.util.logging.config.file=$CATALINA_BASE/conf/logging.properties     \
    org.apache.catalina.startup.Bootstrap
```


```conf
    
```