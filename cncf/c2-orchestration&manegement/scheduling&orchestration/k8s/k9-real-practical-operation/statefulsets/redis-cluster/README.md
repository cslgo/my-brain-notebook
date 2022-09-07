# Setting Up Your Redis Cluster

1. Create a Namespace

```bash
kubectl create ns redis
```

2. Define a Storage Class

Create a storage class, which points to the local storage, using the following manifest code:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
reclaimPolicy: Delete
```

3. Create a Persistent Volume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv1
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/opt/storage/data1"

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv2
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/opt/storage/data2"

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv3
spec:
  storageClassName: local-storage
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/opt/storage/data3"
```


4. Create the ConfigMap

There are a couple important things to note here.

First, change the password of master and slave with your desired password, which is needed for authentication.

Keep your master and slave passwords the same; you will need to set up the failover of the master pod. If the master pod dies or restarts, then any slave pod will be made the master using. Using the same password will ensure easy communication between master and slave.

Second, do not hard code the slaveof value. That’s a placeholder for the master instance address. You need to generate this value on the fly due to the master failover. This value is set dynamically on the StatefulSet deployment section.

Get the ConfigMap code and save the code in a file named [redis-config.yaml](redis-config.yaml). Deploy the ConfigMap in the Redis namespace using the following command:

```bash
kubectl apply -n redis -f redis-config.yaml
```

5. Deploy Redis Using StatefulSet

StatefulSet is a Kubernetes object used to deploy stateful applications such as MySQL, Oracle, MSSQL, and ElasticSearch. You can use the Deployment object if you are planning to deploy stateless applications such as PHP, Jave, or Perl.

The StatefulSet offers ordered pod names starting from zero and recreates the pod with the same name whenever the pod dies or crashes. A pod can fail at any time. The persistent pod identifier uses this feature (recreating the pod with the same name) to match existing persistent volume (storage volume attached to the failed pod) to the newly created pod.

These features are needed when you deploy the stateful application. Therefore, use the StatefulSet controller to deploy the Redis cluster:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis
spec:
  serviceName: redis
  replicas: 3
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      initContainers:
      - name: config
        image: redis:6.2.3-alpine
        command: [ "sh", "-c" ]
        args:
          - |
            cp /tmp/redis/redis.conf /etc/redis/redis.conf
            
            echo "finding master..."
            MASTER_FDQN=`hostname  -f | sed -e 's/redis-[0-9]\./redis-0./'`
            if [ "$(redis-cli -h sentinel -p 5000 ping)" != "PONG" ]; then
              echo "master not found, defaulting to redis-0"

              if [ "$(hostname)" == "redis-0" ]; then
                echo "this is redis-0, not updating config..."
              else
                echo "updating redis.conf..."
                echo "slaveof $MASTER_FDQN 6379" >> /etc/redis/redis.conf
              fi
            else
              echo "sentinel found, finding master"
              MASTER="$(redis-cli -h sentinel -p 5000 sentinel get-master-addr-by-name mymaster | grep -E '(^redis-\d{1,})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})')"
              echo "master found : $MASTER, updating redis.conf"
              echo "slaveof $MASTER 6379" >> /etc/redis/redis.conf
            fi
        volumeMounts:
        - name: redis-config
          mountPath: /etc/redis/
        - name: config
          mountPath: /tmp/redis/
      containers:
      - name: redis
        image: redis:6.2.3-alpine
        command: ["redis-server"]
        args: ["/etc/redis/redis.conf"]
        ports:
        - containerPort: 6379
          name: redis
        volumeMounts:
        - name: data
          mountPath: /data
        - name: redis-config
          mountPath: /etc/redis/
      volumes:
      - name: redis-config
        emptyDir: {}
      - name: config
        configMap:
          name: redis-config
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "local-storage"
      resources:
        requests:
          storage: 500Mi
```

Save the above code in a file named redis-statefulset.yaml and execute using the following command:

```bash
kubectl apply -n redis -f redis-statefulset.yaml
```

6. Create Headless Service

You cannot directly access the application running in the pod. If you want to access the application, you need a Service object in the Kubernetes cluster. Create a headless service for a Redis pod using the following code:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
spec:
  clusterIP: None
  ports:
  - port: 6379
    targetPort: 6379
    name: redis
  selector:
    app: redis
```

Headless service means that only internal pods can communicate with each other. They are not exposed to external requests outside of the Kubernetes cluster.
Save the previous code in a file named redis-service.yaml and execute the code with this command:

```bash
kubectl apply -n redis -f redis-service.yaml
```

7. Check Replication

```bash
kubectl -n redis logs redis-0

kubectl -n redis describe pod redis-0


kubectl -n redis exec -it redis-0 -- sh
redis-cli 
auth 1a2s3dqwe
info replication
```