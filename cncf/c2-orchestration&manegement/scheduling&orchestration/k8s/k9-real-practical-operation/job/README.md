Job
===
任务
---

[echo-job.yaml](echo-job.yaml)

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
  namespace: samples
spec:
  manualSelector: true
  completions: 9  # 指定 job 需要成功运行 pods 的次数，默认值为 1
  parallelism: 3  # 指定 job 在任一时刻应该并发运行 pods 的数量，默认值为 1
  selector:
    matchLabels:
      app: job-pod
  template:
    metadata:
      labels:
        app: job-pod
    spec:
      restartPolicy: Never
      containers:
      - name: echo-c
        image: centos:7.9.2009
        command:    # ["/bin/sh","-c","for i in 10 9 8 7 6 5 4 3 2 1; do echo ${i}; sleep 2; done"]
        - "/bin/sh"
        - "-c"
        - "for i in $(seq 1 10); do echo ${i}; sleep 0.5; done"
```

```shell
#
> kubectl apply -f ./echo-job.yaml
#
> kubectl get job -n samples -o wide
#
> kubectl get pods -n samples -o wide
NAME                                READY   STATUS      RESTARTS   AGE   IP            NODE                 NOMINATED NODE   READINESS GATES
echo-job-4gbtd                      0/1     Completed   0          63s   10.244.3.21   ha-cluster-worker    <none>           <none>
echo-job-4zljt                      0/1     Completed   0          51s   10.244.4.24   ha-cluster-worker2   <none>           <none>
echo-job-bqz7m                      0/1     Completed   0          63s   10.244.4.22   ha-cluster-worker2   <none>           <none>
echo-job-dkljm                      0/1     Completed   0          45s   10.244.5.25   ha-cluster-worker3   <none>           <none>
echo-job-dr5xt                      0/1     Completed   0          57s   10.244.5.23   ha-cluster-worker3   <none>           <none>
echo-job-hqv6w                      0/1     Completed   0          63s   10.244.5.22   ha-cluster-worker3   <none>           <none>
echo-job-ngg82                      0/1     Completed   0          51s   10.244.5.24   ha-cluster-worker3   <none>           <none>
echo-job-sz6dv                      0/1     Completed   0          57s   10.244.4.23   ha-cluster-worker2   <none>           <none>
echo-job-x4t7b                      0/1     Completed   0          45s   10.244.4.25   ha-cluster-worker2   <none>           <none>

#
> kubectl delete -f ./echo-job.yaml

```

# CronJob

[echo-cron-job.yaml](echo-cron-job.yaml)
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: echo-cron-job
  namespace: samples
  labels:
    controller: echo-cron-job
spec:
  schedule: "*/1 * * * *" # 每分钟执行一次
  jobTemplate:
    metadata:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
          - name: echo-cron-c
            image: centos:7.9.2009
            command:    # ["/bin/sh","-c","for i in 5 4 3 2 1;do echo ${i};sleep 3;done"]
            - "/bin/sh"
            - "-c"
            - "for i in `seq 1 10`;do echo ${i};sleep 1;done"
```

