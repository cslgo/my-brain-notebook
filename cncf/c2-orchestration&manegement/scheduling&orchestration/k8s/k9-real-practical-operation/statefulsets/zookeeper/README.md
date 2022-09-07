Running ZooKeeper, A Distributed System Coordinator
===

## Creating a ZooKeeper ensemble 

This tutorial demonstrates running Apache Zookeeper on Kubernetes using StatefulSets, PodDisruptionBudgets, and PodAntiAffinity.

The manifest below contains a Headless Service, a Service, a PodDisruptionBudget, and a StatefulSet.

```bash
kubectl apply -f ./zookeeper.yaml -n kube-ops
```

## Facilitating leader election 

Because there is no terminating algorithm for electing a leader in an anonymous network, Zab requires explicit membership configuration to perform leader election. Each server in the ensemble needs to have a unique identifier, all servers need to know the global set of identifiers, and each identifier needs to be associated with a network address.

Use kubectl exec to get the hostnames of the Pods in the zk StatefulSet.

```bash
for i in 0 1 2; do kubectl exec zk-$i -n kube-ops -- hostname; done

for i in 0 1 2; do echo "myid zk-$i";kubectl exec zk-$i -n kube-ops -- cat /var/lib/zookeeper/data/myid; done

for i in 0 1 2; do kubectl exec zk-$i -n kube-ops -- hostname -f; done

kubectl exec zk-0 -n kube-ops -- cat /opt/zookeeper/conf/zoo.cfg
```

## Sanity testing the ensemble 

The most basic sanity test is to write data to one ZooKeeper server and to read the data from another.

```bash
kubectl exec zk-0 -n kube-ops -- zkCli.sh create /hello world
```

To get the data from the zk-1 Pod use the following command.

```bash
kubectl exec zk-1 -n kube-ops -- zkCli.sh get /hello

```

```bash
kubectl delete statefulset zk -n kube-ops
# 
kubectl apply -f ./zookeeper.yaml -n kube-ops
#
kubectl exec zk-1 -n kube-ops -- zkCli.sh get /hello
#
kubectl get sts zk -n kube-ops -o yaml

```

## Configuring a non-privileged user 

The best practices to allow an application to run as a privileged user inside of a container are a matter of debate. If your organization requires that applications run as a non-privileged user you can use a SecurityContext to control the user that the entry point runs as.

The zk StatefulSet's Pod template contains a SecurityContext.

```yaml
      securityContext:
        runAsUser: 1000
        fsGroup: 1000
```

In the Pods' containers, UID 1000 corresponds to the zookeeper user and GID 1000 corresponds to the zookeeper group.

Get the ZooKeeper process information from the zk-0 Pod.

```bash
kubectl exec zk-0 -n kube-ops -- ps -elf

kubectl exec -ti zk-0 -n kube-ops -- ls -ld /var/lib/zookeeper/data

```

Because the fsGroup field of the securityContext object is set to 1000, the ownership of the Pods' PersistentVolumes is set to the zookeeper group, and the ZooKeeper process is able to read and write its data.

## Managing the ZooKeeper process 

### Updating the ensemble 

The zk StatefulSet is configured to use the RollingUpdate update strategy.

You can use kubectl patch to update the number of cpus allocated to the servers.

```bash
kubectl patch sts zk -n kube-ops --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/cpu", "value":"0.3"}]' 
```

Use kubectl rollout status to watch the status of the update.

```bash
kubectl rollout status sts/zk -n kube-ops
```

Use the kubectl rollout history command to view a history or previous configurations.

```bash
kubectl rollout history sts/zk -n kube-ops
```

Use the kubectl rollout undo command to roll back the modification.

```bash
kubectl rollout undo sts/zk -n kube-ops
```

