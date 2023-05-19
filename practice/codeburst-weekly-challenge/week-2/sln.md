1. k create ns k8s-challenge-2-a
2. k create deploy nginx-deployment --image nginx --replicas 3 --dry-run=client -o yaml > nginx-deploy.yaml
3. Add the resource limit as required:
```
resources:
  limits:
    memory: 64Mi
```
4. k apply -f nginx-deploy.yaml
5. k expose deploy nginx-deploy --name nginx-service --port 4444 --target-port 80
6. tmp cosmintitei/bash-curl `tmp is a bash function that spins up a temporary pod with the given image and drops into a shell inside the container.`
    1. curl nginx-service:444   
 
7. k create ns k8s-challenge-2-b
8. k config set-context --current --namespace k8s-challenge-2-b `kn k8s-challenge-2-b` >> `kn is also a bash function that can change the namespace easily`
9. tmp cosmintitei/bash-curl
    1. curl nginx-service:k8s-challenge-2-b:4444