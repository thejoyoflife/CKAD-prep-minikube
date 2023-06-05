# Need to practice more on:

## Topics:
- vim
- Jsonpath, JQ, Go-Template
- OS Commands/Tools (ls, ps, cat, echo, sudo, chmod, chown, grep, awk, tar, tr, watch, cut, column, sed, xargs, head, tail, less, sort, uniq, bash loops/variables, curl, wget, nc, nslookup, netstat)
- Helm CLI
## Output Format Examples
### JsonPath:
- `k get pods -A -o jsonpath='{.items[*].status.podIP}'`
- `k get pods -o jsonpath='{.items[].spec.containers[*].image}'` => all the images of a random first pod is listed with space in between. NOTE: without a `*`, it deals with a random single object.
- `k get pods -A -o jsonpath='{range .items[*]}Namespace/Name: {.metadata.namespace}/{.metadata.name}{"\n"}{end}'` => normal texts can be placed in between the expressions `{}` except the escape sequence characters i.e. `\n\t` etc.
### Go-Template:
- `k get pods --template='{{range $ind,$pod := .items}}Name: {{$pod.metadata.name}},IP: {{$pod.status.podIP}}{{"\n"}}{{end}}'` => normal texts can be placed in between the expressions `{}` except the escape sequence characters i.e. `\n\t` etc.
- `k get secret mysec --template='{{.data.password | base64decode}}'` => function can be invoked on a field by concantenating it with a `|` character.
### Custom Columns:
- `k get pods -o custom-columns='NAME:metadata.name,IMAGE:spec.containers[*].image` => the images are listed with comma separated.
### JQ:
- Lots of pods are running in qa,alan,test,production namespaces. All of these pods are configured with liveness probe. Please list all pods whose liveness probe have failed in the format of <namespace>/<pod name> per line.
   * `k events -A -o json | jq -r '.items[] | select(.message | contains("Liveness probe failed")) | .involvedObject.namespace + "/" + .involvedObject.name'`
- Finding a pod that has some text in it as labels or annotations.
   * `k get pods -o json | jq -r '.items[] | .metadata.name as $podname | (.metadata.annotations | to_entries[] | select((.key | contains("<some_text>")) or (.value | contains("<some_text>"))) | $podname)' | uniq` => label search can be done in the same way.
## Some important points:
- `k run mypod --image gcr.io/distroless/nodejs20-debian11 -l app=nodejs` => creates a pod named `mypod` with label `app: nodejs` with a container named `mypod` as well. If no label is specified, by default, `run: mypod` label will be assigned to the pod. 
- `k create deploy mydep --image gcr.io/distroless/nodejs20-debian11` will create a deployment named `mydep`, it's `selector` and the pod label are both assigned with `app: mydep` label. The name of the container is given as `nodejs20-debian11` (last part of the image without the tag). The corresponding `replicaset` will have the same `selector` as its deployment with an extra label `pod-template-hash`. The `replicaset` and the underlying pods both get the same labels. And, it is same as the ones specified in the pod with the extra label `pod-template-hash` added.
- `k set image pod/nginx nginx-cont=nginx:alpine` => this just restarts the `nginx-cont` container of the pod `nginx` with the new image `nginx:alpine`; pod itself doesn't restart, hence the IP of it stays the same.
- `pod.spec.containers.securityContext.readOnlyRootFilesystem` can be set to `true` to make a linux container's root filesystem "read-only" - the processes in the container can not write anyting to the root filesystem.
- A deployment can be annotated with `kubernetes.io/change-cause:<some_string>` to get it shown under the "CHANGE-CAUSE" column of its deployment history (`k rollout history`).
- Create an nginx pod that uses 'myuser' as a service account
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set sa -f - myuser --local -o yaml | k apply -f -`
- Create an nginx pod with requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set resources -f - --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --local -o yaml | k apply -f -`
- Copy `/etc/passwd` file from a busybox pod to local folder.
   * `k exec busybox -- tar -cvf -C /etc passwd | tar -xvf -`
- "wget" a set of pods in a single command:
   * `k get pods -l app=foo -o wide | awk '{print $6}' | grep -v IP | xargs -i kubectl run tmp --image busybox --rm -it --restart Never --image-pull-policy IfNotPresent -- wget -qO- \{\}:8080 -T 2`
- "wget" a service a few times to see it load balances to the underlying pods:
   * `k run tmp --image busybox --restart Never --rm -it --image-pull-policy IfNotPresent -- sh -c 'for i in $(seq 1 10); do wget -qO- <service_name>:<port_num>; done'`   
- `pod.spec.volumes.secret/configMap` vs `pod.spec.containers.envFrom.secretRef/configMapRef` - the `envFrom` contains fields with a `Ref` suffix, whereas in the `volumes` field its not.
- `pod.spec.volumes.configMap.name` vs `pod.spec.volumes.secret.secretName` - the one with `secret` contains `name` with `secret` prefix, whereas for the other its just `name`.
- Listing labels and annotations for pods can be done using:
   * `k label pods -l app=v1 --list`
   * `k label pods nginx{1..3} --list`
   * `k annotate pods -l app=v1 --list`
   * `k annotate pods nginx{1..3} --list`
- A list of pods that has label `env` with different values like `dev`,`prod` and a few others. Also, there are other pods without `env` labels. Find out the pods that has `env` label but the value of the label is not `dev` or `prod`.
   * `k get pods -l 'env notin (dev,prod)' -L env` => this will result in pods that has no `env` label as well, which is not corret. `k get pods -l 'env,env notin (dev,prod) -L env` => this ensures that `env` label is present on top of verifying the other condition.
   * `k get pods -l '!env'` => this returns pods that don't have `env` label.
- To make kubectl wait for certain events to occur:
   * `k wait --for=condition=complete jobs/pi --timout 10s`
   * `k wait --for=jsonpath='{.status.phase}'=Running pods -l app=nginx --timeout 15s`
- "CronJob" has `startingDeadlineSeconds`, whereas "Job" has `activeDeadlineSeconds` - one is used to set the time limit (in seconds) to start the CronJob, the other one for the job (which is part of the "CronJob") to finish.   
- Copy an existing pod
   * `k debug <existing_pod_name> --copy-to <new-pod-name> --set-image=<existing_cont_name>=<same_image>` => `--set-image` needs to be given even though it seems to be redundant.
- Ephemeral volumes are, by default, mounted in the container filesystems with full permissions for everyones and with owner/group as root. Persistent volumes are also mounted with owner/group as root, but the write permission on the directory is prohibited for group and other users. For both type of volumes, no write permissions are given to group or others for new files/directories created in the mount point (`i.e. -rw-r--r--`).
    * Ephemeral mountpoint permission would look like this:
    `drwxrwxrwx    2 root     root          4096 May  20 14:47 /tmp/share`
    * PV mountpoint permission would look like this:
    `drwxr-xr-x    2 root     root            40 May  20 14:47 /tmp/pvshare`
- The permission of the mounted directory can be manually changed from an `init container` so that the general containers do not interfere (e.g. delete files created by one container from another container) with each other. `chmod og-w -R /tmp/share` can be used from a busybox init container to change the permission as required. For, persistent volumes, the permission is already set like this automatically by the system.
- `securityContext -> fsGroup` in the pod spec can be used to change the "Group Ownership" of the mounted volume and also to set the `setgid` bit in the directory permission.
- Verifying access permission for a service account can be done like this:
   * `kubectl auth can-i get pods -n dev --as=system:serviceaccount:test:myaccount` => verifies whether `myaccount` service account in `test` namespace can get pods in the `dev` namespace or not. NOTE: `system:serviceaccount` string must be used for service account verification.   