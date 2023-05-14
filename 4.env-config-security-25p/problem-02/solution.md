- no errors are observed in the pod.
- `serviceAccount` is deprecated. `serviceAccountName` should be used instead which is already being used in the env.yaml file.
- delete pod service-list
- Edit pod.yml
```
  serviceAccountName: api-call
  serviceAccount: api-call
```
- k apply -f pod.yml
- k logs service-list