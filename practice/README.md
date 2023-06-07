# Need to practice more on:

## Topics:
- vim
- Jsonpath, JQ, Go-Template
- OS Commands/Tools (ls, ps, cat, echo, sudo, chmod, chown, grep, awk, tar, tr, watch, cut, column, sed, xargs, head, tail, less, sort, uniq, bash loops/variables, curl, wget, nc, nslookup, netstat)
- Helm CLI
## Output Format Examples
### JsonPath:
<details><summary>Show all the Pod IPs in all namespaces</summary>
<p>

```bash
k get pods -A -o jsonpath='{.items[*].status.podIP}'
```
</p>
</details>
<details><summary>Show all the images of a single multiconainer pod in the current namespace</summary>
<p>

```bash
k get pods -o jsonpath='{.items[].spec.containers[*].image}'
```
NOTE: All the images of a random first pod is listed with spaces in between. without a `*`, it deals with a random single object.
</p>
</details>
<details><summary>Show all the pods in all namespaces with each one in a specific format "<b>Namespace: &lt;pod_namespace&gt;, Name: &lt;pod_name&gt;</b>" in each line.</summary>
<p>

```bash
k get pods -A -o jsonpath='{range .items[*]}Namespace: {.metadata.namespace}, Name: {.metadata.name}{"\n"}{end}'
```
NOTE: Normal texts can be placed in between the expression `{}` syntax except the escape sequence characters i.e. `\n\t` etc.
</p>
</details>

### Go-Template:
<details><summary>Show all the pod names in all the namespaces with their IP address with each one in a specific format "<b>Name: &lt;pod_name&gt;, IP: &lt;pod_ip&gt;</b>" in each line.</summary>
<p>

```bash
k get pods -A --template='{{range $ind, $pod := .items}}Name: {{$pod.metadata.name}}, IP: {{$pod.status.podIP}}{{"\n"}}{{end}}'
```
NOTE: Normal texts can be placed in between the expression `{{}}` syntax except the escape sequence characters i.e. `\n\t` etc.
</p>
</details>
<details><summary>Decode "<b>password</b>" key value from a secret called "<b>mysec</b>" without using any extra OS cli tool.</summary>
<p>

```bash
k get secret mysec --template='{{.data.password | base64decode}}''
```
NOTE: Function can be invoked on a field by concantenating it with a `|` character.
</p>
</details>
<details><summary>Show all the pod names in the current namespace that are not in "<b>ready</b>" state</summary>
<p>

```bash
k get pods --template='{{range $pi, $pod := .items}}{{range $si, $stat := $pod.status.containerStatuses}}{{if not $stat.ready}}{{printf "%s\n" $pod.metadata.name}}{{end}}{{end}}{{end}}'
```
</p>
</details>

### Custom Columns:
<details><summary>Show all the pod and their images in the current namespace under "<b>NAME</b>" and "<b>IMAGE</b>" columns.</summary>
<p>

```bash
k get pods -o custom-columns='NAME:metadata.name,IMAGE:spec.containers[*].image'
```
NOTE: The images are listed with comma separated as opposed to normal `jsonpath` output where items are shown `space` spearated.
</p>
</details>

### JQ:
<details><summary>Lots of pods are running in qa,dev,test,production namespaces. All of these pods are configured with liveness probe. List all the pods whose liveness probe have failed in the format of "<b>&lt;namespace&gt;/&lt;pod_name&gt;</b>" per line.</summary>
<p>

```bash
k events -A -o json | jq -r '.items[] | select(.message | contains("Liveness probe failed")) | .involvedObject.namespace + "/" + .involvedObject.name'
```
</p>
</details>   
<details><summary>Finding a pod that has some text in it as labels or annotations.</summary>
<p>

```bash
k get pods -o json | jq -r '.items[] | .metadata.name as $podname | (.metadata.annotations | to_entries[] | select((.key | contains("<some_text>")) or (.value | contains("<some_text>"))) | $podname)' | uniq 
```
Note: Label search can be done in the same way.
</p>
</details>

## Some important points:
- 
<p>

```bash
k run mypod --image gcr.io/distroless/nodejs20-debian11 -l app=nodejs
```
creates a pod named `mypod` with label `app: nodejs` with a container named `mypod` as well. If no label is specified, by default, `run: mypod` label will be assigned to the pod. 
</p>

- 
<p>

```bash 
k create deploy mydep --image gcr.io/distroless/nodejs20-debian11
```
Will create a deployment named `mydep`, it's `selector` and the pod label are both assigned with `app: mydep` label. The name of the container is given as `nodejs20-debian11` (last part of the image without the tag). The corresponding `replicaset` will have the same `selector` as its deployment with an extra label `pod-template-hash`. The `replicaset` and the underlying pods both get the same labels. And, it is same as the ones specified in the pod with the extra label `pod-template-hash` added.
</p>

- 
<p>

```bash
k set image pod/nginx nginx-cont=nginx:alpine
```
This just restarts the `nginx-cont` container of the pod `nginx` with the new image `nginx:alpine` - pod itself doesn't restart; hence the IP of it stays the same.
</p>

- `pod.spec.containers.securityContext.readOnlyRootFilesystem` can be set to `true` to make a linux container's root filesystem as "__read-only__" - the processes in the container can not write anyting to the root filesystem.

- A deployment can be annotated with `kubernetes.io/change-cause:<some_string>` to get it shown under the "__CHANGE-CAUSE__" column of its deployment history at the row of it's current version(`k rollout history`).

- <details><summary>Create an nginx pod that uses "<i>myuser</i>" as a service account.</summary>

  ```bash
  k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set sa -f - myuser --local -o yaml | k apply -f -
  ```
</details>   

- <details><summary>Create an nginx pod with requests "<i>cpu=100m,memory=256Mi</i>" and "<i>limits cpu=200m,memory=512Mi</i>".</summary>

  ```bash
  k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set resources -f - --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --local -o yaml | k apply -f -
  ```
</details>

- <details><summary>Copy "<i>/etc/passwd</i>" file from a busybox pod to the current local folder of the terminal.</summary>

  ```bash
  k exec busybox -- tar -cvf - -C /etc passwd | tar -xvf -
  ```
</details>

- <details><summary>"<i>wget</i>" a set of pods in a single command.</summary>

  ```bash
  k get pods -l app=foo -o wide | awk '{print $6}' | grep -v IP | xargs -i kubectl run tmp --image busybox --rm -it --restart Never --image-pull-policy IfNotPresent -- wget -qO- \{\}:8080 -T 2
  ```
</details>

- <details><summary>"<i>wget</i>" a service a few times to see it balancing loads to the underlying pods.</summary>

  ```bash
  k run tmp --image busybox --restart Never --rm -it --image-pull-policy IfNotPresent -- sh -c 'for i in $(seq 1 10); do wget -qO- <service_name>:<port_num>; done'
  ```
</details>

- `pod.spec.volumes.secret/configMap` vs `pod.spec.containers.envFrom.secretRef/configMapRef` - the `envFrom` contains fields with a `Ref` suffix, whereas in the `volumes` field its not.

- `pod.spec.volumes.configMap.name` vs `pod.spec.volumes.secret.secretName` - the one with `secret` contains `name` with `secret` prefix, whereas for the other its just `name`.

- Listing labels and annotations for pods can be done using:
   * `k label pods -l app=v1 --list`
   * `k label pods nginx{1..3} --list`
   * `k annotate pods -l app=v1 --list`
   * `k annotate pods nginx{1..3} --list`

- <details><summary>A list of pods that has label "<i>env</i>" with different values like "<i>dev</i>","<i>prod</i>" and a few others. Also, there are other pods without "<i>env</i>" labels. Find out the pods that has "<i>env</i>" label but the value of the label is not "<i>dev</i>" or "<i>prod</i>".</summary>

   * 
   ```bash
   k get pods -l 'env notin (dev,prod)' -L env
   ```
   This will result in pods that has no `env` label as well, which is incorret. 
   
   ```bash
   k get pods -l 'env,env notin (dev,prod) -L env
   ``` 
   This ensures that `env` label is present along with satisfying the other condition.
   
   * 
   ```bash
   k get pods -l '!env'
   ``` 
   This returns pods that don't have `env` label associated with them.
</details>  

- <details><summary>To make <i>kubectl</i> wait for a certain time for a <i>job</i> to complete and also write another command where it will wait upto a certain time for all the pods in the current namespace with a certain label to be in <i>Running</i> state.</summary>
   
   *   
   ```bash
   k wait --for=condition=complete jobs/pi --timout 10s
   ```   
   *    
   ```bash
   k wait --for=jsonpath='{.status.phase}'=Running pods -l app=nginx --timeout 15s
   ```
</details>   

- `CronJob` has `startingDeadlineSeconds`, whereas `Job` has `activeDeadlineSeconds` - one is used to set the time limit (in seconds) to start the CronJob, the other one for the job (which is part of the "CronJob") to finish.   

- <details><summary>Copy an existing pod</summary>

  ```bash
  k debug <existing_pod_name> --copy-to <new-pod-name> --set-image=<existing_cont_name>=<same_image>
  ```
  `--set-image` needs to be given even though it seems to be redundant.
</details>

- Ephemeral volumes are, by default, mounted in the container filesystems with full permissions for everyones and with owner/group as root. Persistent volumes are also mounted with owner/group as root, but the write permission on the directory is prohibited for group and other users. For both type of volumes, no write permissions are given to group or others for new files/directories created in the mount point (`i.e. -rw-r--r--`).
    * Ephemeral mountpoint permission would look like this:
    `drwxrwxrwx    2 root     root          4096 May  20 14:47 /tmp/share`
    * PV mountpoint permission would look like this:
    `drwxr-xr-x    2 root     root            40 May  20 14:47 /tmp/pvshare`

- The permission of the mounted directory can be manually changed from an `init container` so that the general containers do not interfere (e.g. delete files created by one container from another container) with each other. `chmod og-w -R /tmp/share` can be used from a busybox init container to change the permission as required. For, persistent volumes, the permission is already set like this automatically by the system.

- `securityContext -> fsGroup` in the pod spec can be used to change the "Group Ownership" of the mounted volume and also to set the `setgid` bit in the directory permission.

- <details><summary>How to verify access permission (authorization) for a service account?</summary>

  ```bash
  k auth can-i get pods -n dev --as=system:serviceaccount:test:myaccount
  ```
  Verifies whether `myaccount` service account in `test` namespace can get pods in the `dev` namespace or not. NOTE: `system:serviceaccount` string must be used for service account verification.
</details>

- `volumes -> emptyDir -> medium: Memory (& sizeLimit: 1Gi)` => this can be used to create a `tmpfs` (memory based) based volume. Size of the mounted volume is determined as the lower of `volumes -> sizeLimit` and `resources -> limits -> memory`. If one of them is specified, then that becomes the size of the volume. In case none of them is specified, the size is then based on the memory size of the node where the pod gets assigned.