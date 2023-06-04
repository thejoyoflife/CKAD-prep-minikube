## Need to practice more on:

### Topics:
- vim
- Jsonpath, JQ, Go-Template
- OS Commands/Tools (ls, ps, cat, echo, sudo, chmod, chown, grep, awk, tar, watch, cut, column, sed, xargs, head, tail, less, bash loops/variables, curl, wget, nc, nslookup, netstat)
- Helm CLI

### Some specific points:
- `pod.spec.containers.securityContext.readOnlyRootFilesystem` can be set to `true` to make a linux container's root filesystem "read-only" - the processes in the container can not write anyting to the root filesystem.
- A deployment can be annotated with `kubernetes.io/change-cause:<some_string>` to get it shown under the "CHANGE-CAUSE" column of its deployment history (`k rollout history`).
- Create an nginx pod that uses 'myuser' as a service account
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set sa -f - myuser --local -o yaml | k apply -f -`
- Create an nginx pod with requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set resources -f - --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --local -o yaml | k apply -f -`
- Copy `/etc/passwd` file from a busybox pod to local folder.
   * `k exec busybox -- tar -cvf -C /etc passwd | tar -xvf -`
- Lots of pods are running in qa,alan,test,production namespaces. All of these pods are configured with liveness probe. Please list all pods whose liveness probe have failed in the format of <namespace>/<pod name> per line.
   * `k events -A -o json | jq -r '.items[] | select(.message | contains("Liveness probe failed")) | .involvedObject.namespace + "/" + .involvedObject.name'`
- "wget" a set of pods in a single command:
   * `k get pods -l app=foo -o wide | awk '{print $6}' | grep -v IP | xargs -i kubectl run tmp --image busybox --rm -it --restart Never --image-pull-policy IfNotPresent -- wget -qO- \{\}:8080 -T 2`
- "wget" a service a few times to see it load balances to the underlying pods:
   * `k run tmp --image busybox --restart Never --rm -it --image-pull-policy IfNotPresent -- sh -c 'for i in $(seq 1 10); do wget -qO- <service_name>:<port_num>; done'` 
- Finding a pod that has some text in it as labels or annotations.
   * `k get pods -o json | jq -r '.items[] | .metadata.name as $podname | (.metadata.annotations | to_entries[] | select((.key | contains("<some_text>")) or (.value | contains("<some_text>"))) | $podname)' | uniq` => label search can be done in the same way.  
- In the `volumes` section of a Pod, the "configmap" volume is defined like `configMap -> name` whereas the "secret" volume is defined with `secret -> secretName`. Its to be noted that for secret, `secretName` is being used, whereas for configMap, only `name` is used.
- Listing labels and annotations for pods can be done using:
   * `k label pods -l app=v1 --list`
   * `k label pods nginx{1..3} --list`
   * `k annotate pods -l app=v1 --list`
   * `k annotate pods nginx{1..3} --list`
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
   