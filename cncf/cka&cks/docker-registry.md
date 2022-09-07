
```bash
kubectl create secret docker-registry registry-secret \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=caojiaqing \
    --docker-password=PessW3rd \
    --docker-email=caojiaqing@aliyun.com
```

```yaml
apiVersion: v1
kind: Pod
metadata: null
name: foo
namespace: awesomeapps
spec: null
  containers:
    - name: foo
    image: 'johndoe/awesomeapp:v1'
  imagePullSecrets:
    - name: registry-secret
```

