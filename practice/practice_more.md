## Need to practice more on:

### Topics:
- vim
- Jsonpath, JQ, Go-Template
- OS Commands/Tools (ls, cat, echo, sudo, chmod, chown, tar, sed, xargs, bash loops/variables, curl, wget, nc)
- Helm CLI

### Some specific points:
- Create an nginx pod that uses 'myuser' as a service account
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set sa -f - myuser --local=true -o yaml | k apply -f -`
- Create an nginx pod with requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi
   * `k run nginx --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set resources -f - --requests=cpu=100m,memory=256Mi --limits=cpu=200m,memory=512Mi --local=true -o yaml | k apply -f -`
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

   