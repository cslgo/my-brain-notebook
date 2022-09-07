
```shell

❯ kubectl create namespace samples

# create clusterip service
❯ kubectl create service clusterip my-svc-ci --tcp=80:8080 -n samples
service/my-svc-ci created
❯ kubectl get svc -n samples -o wide
NAME        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE   SELECTOR
my-svc-ci   ClusterIP   10.96.217.9   <none>        80/TCP    35s   app=my-svc-ci
❯ curl 10.96.217.9:80

❯ kubectl describe svc my-svc-ci -n samples
Name:              my-svc-ci
Namespace:         samples
Labels:            app=my-svc-ci
Annotations:       <none>
Selector:          app=my-svc-ci
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.217.9
IPs:               10.96.217.9
Port:              80-8080  80/TCP  # 80 pod port 8080 container port
TargetPort:        8080/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>

# create nodeport service
❯ kubectl create service nodeport my-svc-np --tcp=1234:80 -n samples
service/my-svc-np created
❯ kubectl get svc -n samples -o wide
NAME        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE   SELECTOR
my-svc-ci   ClusterIP   10.96.217.9    <none>        80/TCP           10m   app=my-svc-ci
my-svc-np   NodePort    10.96.74.164   <none>        1234:31171/TCP   14s   app=my-svc-np
❯ kubectl describe svc my-svc-np -n samples
Name:                     my-svc-np    
Namespace:                samples      
Labels:                   app=my-svc-np
Annotations:              <none>
Selector:                 app=my-svc-np
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.74.164
IPs:                      10.96.74.164
Port:                     1234-80  1234/TCP
TargetPort:               80/TCP
NodePort:                 1234-80  31171/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
❯ curl 172.24.17.130:31171
curl: (7) Failed to connect to 172.24.17.130 port 31171: Connection refused

# create headless service
❯ kubectl create service clusterip my-svc-hl --clusterip="None" -n samples
❯ kubectl describe svc my-svc-hl -n samples
Name:              my-svc-hl    
Namespace:         samples      
Labels:            app=my-svc-hl
Annotations:       <none>
Selector:          app=my-svc-hl
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                None
IPs:               None
Session Affinity:  None
Events:            <none>
#
❯ kubectl run hello-nginx --image=nginx:1.21 -n samples
pod/hello-nginx created
❯ kubectl get pods -n samples -o wide
NAME          READY   STATUS    RESTARTS   AGE   IP           NODE                NOMINATED NODE   READINESS GATES
hello-nginx   1/1     Running   0          40s   10.244.3.2   ha-cluster-worker   <none>           <none>
# ...
❯ kubectl create deployment hello-nginx --image nginx:1.21 --namespace samples
deployment.apps/nginx-dp created
❯ kubectl expose deployment hello-nginx --type=ClusterIP --name=my-nginx --type=ClusterIP  --port 8090 --target-port 80 -n samples
service/my-nginx exposed
❯ kubectl get svc -n samples -o wide
NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
my-nginx    ClusterIP   10.96.41.235    <none>        8090/TCP         31s   app=hello-nginx
my-svc-ci   ClusterIP   10.96.248.241   <none>        80/TCP           22h   app=my-svc-ci
my-svc-hl   ClusterIP   None            <none>        <none>           22h   app=my-svc-hl
my-svc-np   NodePort    10.96.237.38    <none>        1234:31473/TCP   22h   app=my-svc-np
❯ curl 172.24.28.233:8090
curl: (7) Failed to connect to 172.24.28.233 port 8090: Connection refused
❯ kubectl expose deployment hello-nginx --type=ClusterIP --name=my-nginx-np --type=NodePort  --port 8090 --target-port 80 -n samples
❯ kubectl get svc -n samples -o wide
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE     SELECTOR
my-nginx      ClusterIP   10.96.41.235    <none>        8090/TCP         8m11s   app=hello-nginx
my-nginx-np   NodePort    10.96.197.45    <none>        8090:30311/TCP   13s     app=hello-nginx
❯ curl 172.24.28.233:30311
❯ kubectl port-forward svc/my-nginx-np 8090:8090 -n samples
❯ curl 172.24.28.233:8090
❯ curl localhost:8090
#
❯ wget https://kubernetes.io/examples/admin/dns/busybox.yaml

❯ kubectl apply -f busybox.yaml

❯ kubectl exec -it busybox -- nslookup busybox
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      busybox
Address 1: 10.244.5.3 busybox

```