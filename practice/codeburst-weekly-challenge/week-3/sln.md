1. k apply -f pv.yaml
2. k apply -f pvc.yaml
3. k create cj mycj --image busybox --schedule '*/1 * * * *' --dry-run=client -o yaml -- sh -c "hostname >> /tmp/vol/storage" > cj.yaml
4. Add `successfulJobsHistoryLimit: 4` to the cj.yaml file under the CronJob spec.
5. k apply -f cj.yaml
6. CronJob creates a separate Job instance in every miniutes, which in turn creates one or more pods (based on the `concurrencyPolicy`, `parallelism` and remaining `completions` count) to execute the specified image. The following command can be used to view the job instances pertaining to a specific CronJob (because of "substring/regex" match not available either in `jsonpath` or `go-template` expressions, we can use the `jq` cli tool instead):
```k get jobs -o json | jq -r '.items[] | select(.metadata.name | test("^mycj.*")) | .metadata.name'.```
This command will verify that only 4 job instances can exist at any point of time - `successfulJobsHistoryLimit`. Also, there will be 8 pods in total - each two pods belong to a separate job instance.
7. minikube ssh -n <node_name> --native-ssh=false
8. tail -f /tmp/k8s-challenge-3/storage
   
   This should show all the name of the pods created by the cronjob so far.