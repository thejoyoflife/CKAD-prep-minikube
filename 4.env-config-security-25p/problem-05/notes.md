- list of pods, describe pod
- get secrets , list secrets -A
- allow access to only specific cronjob

- CRD api group permission
- all of them with all resource in all api group


-  # "" indicates the core API group
- APISERVER=https://kubernetes.default.svc

- k run k8sapi --image=ivplay4689/k8sapi --restart=Never --env=QUERY_PATH=v1

GET https://127.0.0.1:53215/api/v1/namespaces/default/pods?limit=500

GET https://127.0.0.1:53215/api/v1/namespaces/default/pods/tmp