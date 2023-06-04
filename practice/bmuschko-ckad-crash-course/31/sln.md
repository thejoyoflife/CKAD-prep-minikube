- `k apply -f setup.yaml`
- `k get ns --show-labels` => note down the labels of the `k1` namespace (`role=consumer`)
- `k get netpol -n k2` => the existing policy denies all traffic to the nginx pod in the namespace. we need to allow it by creating a seperate network policy.
- Verify the communication is not working:
    * `k get pods -o wide --show-labels -n k2` => note down the ip address and label of the nginx pod
    * `k exec -n k1 busybox -- nc -zvw 2 <nginx_pod_ip> 80` => this should time out as the existing "deny" network policy.
- Create a network policy that allows all pods from namespace `k1` to communicate with the nginx pod in `k2` namespace. Hint: use the label of the `k1` namespace as part of the `namespaceSelector`.
- `k apply -f netpol.yaml`
- Run the previous test again. This time it should success.
- Try this test from another temporary pod in another namespace (e.g. `default`). This should not be successful as the above policy only allows ingress traffic from `k1` namespace alone. 