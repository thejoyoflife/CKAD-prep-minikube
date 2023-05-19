### #1

- `k run hello --image bonomat/nodejs-hello-world --restart Never --port 3000 --dry-run=client -o yaml > pod.yaml` - change the pod definition to include the `readinessProbe` and `livenessProbe` as per the requirement.
- `k create -f pod.yaml`
- `k exec hello -it -- sh`
   * `curl localhost:3000`
- `k logs hello` or `k logs pod/hello`

### #2
- `k apply -f failing-pod.yaml`
- `k get pod/failing-pod` - should be in Running status.
- `k logs failing-pod` - should show an error related to non-existent directory where the current timestamp should be written to.
- `k exec failing-pod -it -- sh`
   * `mkdir -p /root/tmp`
- `k exec failing-pod -- tail -f /root/tmp/curr-date.txt` - should tail the content of the file containing the current timestamps every 5 seconds.
- `k delete -f failing-pod.yaml --force` - `--force` will delete the pod immediately without waiting for it to shudown gracefully.