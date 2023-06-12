- Run the 3 pods:
    * `k run nginx05 --image nginx --port 80 --restart Never --image-pull-policy IfNotPresent`
    * `k run httpd05 --image httpd --port 80 --restart Never --image-pull-policy IfNotPresent`
    * `k run redis05 --image redis --port 6379 --restart Never --image-pull-policy IfNotPresent`
- `k get pods -o wide --show-labels` => Note down the IP addresses and labels of the pods.   
- Run a `busybox` sidecar container for each of the above 3 pods:
    * `k debug nginx05 --image busybox -c sidecar -- sleep infinity`
    * `k debug httpd05 --image busybox -c sidecar -- sleep infinity`
    * `k debug redis05 --image busybox -c sidecar -- sleep infinity`
- Create a "__deny-all-except-dns__" kind of `NetworkPolicy` object to disable all `ingress` traffic for all the pods in the namespace, and only allow `egress` DNS traffic from all of them. Apply the policy: `k apply -f deny-all.yaml`.
- Verify the connectivity between the pods and internet. At this time, only the DNS traffic should be allowed for each of the above pods - no `ingress` traffic should be able to reach those pods. To test the connectivity as per the requirement, try by connecting to each of the __sidecar__ containers from those 3 pods from 3 separate terminals. Also, run and `exec` on a shell of a temporary pod in a different namespace to test/simulate `ingress` traffic to those pods from the internet (`k run tmp -n <another_namespace> --image busybox -it --rm --restart Never --image-pull-policy IfNotPresent -- sh`).
    * Use `wget -qO- <pod_ip> -T 2` to test web connectivity between `nginx05` and `httpd05` pods.
    * Use `wget -qO- ifconfig.me -T 2` to test `egress` connectivity from the pods to the internet.
    * Use `nc -vzw 2 <redis05_ip> 6379` to test connectivity to the `redis05` pod.
    * Run those above commands from the terminal where the `tmp` pod is running to simulate `ingress` traffic from the internet. 
- Now, create three `NetworkPolicy` objects applied to each of the above 3 pods - `nginx05-netpol.yaml`, `httpd05-netpol.yaml` and `redis05-netpol.yaml`. And, apply those policies: `k apply -f nginx05-netpol.yaml -f httpd05-netpol.yaml -f redis05-netpol.yaml`. Then, verify the connectivity again by following the steps mentioned in previous point.
- The information flow that is being established is like this: __End-User::httpd05::nginx05::redis05__.