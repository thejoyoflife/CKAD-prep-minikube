- `k create ns ckad-prep`
- `kn ckad-prep`
- `k run mypod --image nginx:2.3.5 --restart Never --image-pull-policy IfNotPresent` - there is an error.
- `k get pod mypod` - will give an hint under the "STATUS" colum regarding the error.
- `k describe pod mypod | grep -i warning > pod-error.txt` - saves the error in a file.
- `k set image pod mypod mypod=nginx:1.15.12`
- `k get pods mypod` - should show the pod status as Running.
- `k exec mypod -- ls` - listing the directory
- `k get pod mypod -o wide` - note down the IP address
- `tmp busybox`
   * `wget -qO- <pod_ip>`
   - `k logs mypod` - should show the access log of the above request by wget.
- `k delete pod mypod --force --grace-period=0` 
- `k delete ns ckad-prep`   