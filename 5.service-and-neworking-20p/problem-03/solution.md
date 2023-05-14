- 1. Allow frontend to a specific port of backend as well as any DNS traffic.
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: fe-be-dns
spec:
  policyTypes:
  - Egress
  podSelector:
    matchLabels:
      app: frontend
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 80
  - ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```
- 2. Allow frontend to a specific port of backend as well as DNS traffic targeted to kube-dns system alone.
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: fe-be-kube-dns
spec:
  policyTypes:
  - Egress
  podSelector:
    matchLabels:
      app: frontend
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 80
  - to:
    - podSelector:
        matchLabels:
          k8s-app: kube-dns
      namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
 ```      