- delete pod service-list
- Edit pod.yml
```
  serviceAccountName: api-call
  serviceAccount: api-call
```
- k apply -f pod.yml
- k logs service-list