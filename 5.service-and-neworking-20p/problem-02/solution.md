### 4. Problem in the sheldon service
- The service is in different namespace to where the ingress does reside. An `ExternalName` type of service can be created in the Ingress namespace that can act as a proxy between the namespaces. 
```
apiVersion: v1
kind: Service
metadata:
  name: sheldon-svc-bridge
  namespace: ch5-earth
spec:
  type: ExternalName
  externalName: sheldon.ch5-mars
```
- Change the Ingress definition so that it refers to the above defined ExternalName service instead of the original service in different namespace.
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ch5p02subtask2
  namespace: ch5-earth
spec:
  defaultBackend:
    service:
      name: ch5404
      port:
        number: 80
  rules:
  - host: bigbangtheory.com
    http:
      paths:
      - pathType: Prefix
        path: "/penny"
        backend:
          service:
            name: penny
            port:
              number: 80
      - pathType: Prefix
        path: "/sheldon"
        backend:
          service:
            name: sheldon-svc-bridge
            port:
              number: 80
```