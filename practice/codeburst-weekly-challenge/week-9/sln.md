- k apply -f scenario.yaml
- k get svc nginx `note the port and external ip`
- k get deploy nginx -o yaml > deploy.yaml
- Change deploy.yaml like below:
```
spec:
  containers:
  - image: bash
    name: sidecar
    volumeMounts:
    - mountPath: /tmp/logs
      name: logs
    command:
      - "/bin/sh"
      - "-c"
      - "tail -f /tmp/logs/access.log"
  - image: nginx
    imagePullPolicy: Always
    name: nginx
```
- curl <external_ip of nginx service>:1234
- k logs deploy/nginx -c sidecar -f