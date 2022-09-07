

```
$ kubectl create namespace sl

$ kubectl run nginx --image=nginx:1.20 -n sl --labels=tier=frontend

$ kubectl expose pod nginx --port=80 --target-port=80 --name=web-pod-nginx --type=NodePort -n sl

$ kubectl create ingress web --class=nginx --rule="sl.me/=web-pod-nginx:80" -n sl --dry-run=client -o yaml > sl-ingress-web.yaml

$ kubectl create -f ingress/ingress-nginx-1.1.0.yaml

$ kubectl scale --replicas=3 deployment/ingress-nginx-controller --record -n ingress-nginx

$ kubectl create -f sl-ingress-web.yaml

$ kubectl get ingress -n sl
NAME   CLASS   HOSTS   ADDRESS                               PORTS   AGE
web    nginx   sl.me   10.10.10.24,10.10.10.25,10.10.10.26   80      15s

```

In host `vi /etc/hosts`

```
127.0.0.1 sl.me
```

And

```bash
$ kubectl get svc -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.109.107.96   <none>        80:31468/TCP,443:30127/TCP   21m
ingress-nginx-controller-admission   ClusterIP   10.105.172.27   <none>        443/TCP                      21m

```

In host terminal or web browser

```
curl sl.me:31468
```

success!

