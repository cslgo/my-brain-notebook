# Setting Up Your Mysql Cluster

## Installing

```
kubectl create ns -n mysql-cluster
kubectl apply -f . -n mysql-cluster
```

## Sending client traffic 

```bash
kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
  mysql -h mysql-0.mysql.mysql-cluster <<EOF
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES ('hello');
EOF
```

Use the hostname mysql-read to send test queries to any server that reports being Ready:

```bash
kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
  mysql -h mysql-read.mysql-cluster -e "SELECT * FROM test.messages"
```

To demonstrate that the mysql-read Service distributes connections across servers, you can run SELECT @@server_id in a loop:

```bash
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
  bash -ic "while sleep 1; do mysql -h mysql-read.mysql-cluster -e 'SELECT @@server_id,NOW()'; done"
```

## Simulate Pod and Node failure 

### Break the Readiness probe 

The readiness probe for the mysql container runs the command mysql -h 127.0.0.1 -e 'SELECT 1' to make sure the server is up and able to execute queries.

One way to force this readiness probe to fail is to break that command:

```bash
kubectl exec mysql-2 -c mysql -n mysql-cluster -- mv /usr/bin/mysql /usr/bin/mysql.off
```