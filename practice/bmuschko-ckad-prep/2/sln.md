### #1
- Create a config.txt file with the two key/value pairs as mentioned.
- `k create cm db-config --from-env-file=config.txt`
- `k run backend --image nginx --restart Never --image-pull-policy IfNotPresent --dry-run=client -o yaml > pod.yaml` - Change the file to include `envFrom -> - configMapRef -> name` fields.
- `k apply -f pod.yaml`
- `k exec backend -- env | grep -i db` - this should show the key/value pairs in the `config.txt` as environment variables in the pod.

### #2
- `k create secret generic db-credentials --from-literal=db-password=password`
- Change the `pod.yaml` file to include the secret key as an environment variable.
- `k replace -f pod.yaml --force` - need to force replace the existing pod to take the change into effect.
- `k exec backend -- env | grep -i db` - it should show the new secret key value as an added environment variable.

### #3
- `k run secured --image nginx --restart Never --image-pull-policy IfNotPresent --dry-run=client -o yaml > secured.yaml` - Change the file to add `securityContext -> fsGroup` field under the pod spec section and mount an emptyDir volume in the container at `/data/app` path.
- `k exec secured -- ls -ld /data/app` - the permission should show `3000` as the GID, and also `setgid (s)` bit is set for the group permission.
- `k exec secured -it -- sh`
   * `touch /data/app/logs.txt`
   * `ls -l /data/app` - the GID of `logs.txt` file should be `3000`.

### #4
- `k create ns rq-demo`
- `kn rq-demo`
- `k create quota apps --hard=requests.cpu=0.5,requests.memory=50m,pods=2`
- `k run test --image nginx --restart Never --image-pull-policy IfNotPresent --dry-run=client -o yaml > rq-pod.yaml` - Change the file to include values for the resource requests that exceeds the quota.
- `k create -f rq-pod.yaml` - this should throw an error right away because of exceeding the quota values. 
- `k edit quota apps` - increase the `cpu` and `memory` limits so that the pod creation is allowed.
- `k create -f rq-pod.yaml` - now the pod should be created successfully.
- `k describe quota apps` - this will show the `Used` values for each of the quota fields.

### #5
- `k create sa backend-team`
- `k run backend --image nginx --restart Never --image-pull-policy IfNotPresent --dry-run=client -o yaml > sa-pod.yaml` - Change the pod spec to include `serviceAccountName` field with the value `backend-team`.
- `k exec backend -- cat /var/run/secrets/kubernetes.io/serviceaccount/token` - this will show the token for the `backend-team` service account.