### #1
1. `k create deploy myapp --image nginx --replicas 2 --port 80`
2. `k expose deploy myapp`
3. `k get svc -l app=myapp` - note the cluster ip
4. `k run busybox --image busybox --restart Never --rm -it -- sh`
   * `wget -qO- <cluster_ip>` 
5. `k edit svc myapp` - change the `type` from `ClusterIP` to `NodePort`. Save the changes.
6. `k get svc -l app=myapp` - a nodeport has been assigned to the service.
7. `wget -qSO /dev/null <a_node_ip>:<node_port>` - should return 200 status code in the response header.

### #2
1. k create ns app-stack
2. kn app-stack
3. k get pods -o wide
4. Open two separate terminals to start the following two debug sessions and keep them open.
5. k debug pod frontend --image nicolaka/netshoot -c debugger it
   * nc -zvw 2 <database_pod_ip> 3306 - `this should be successful`
6. k debug pod backend --image nicolaka/netshoot -c debugger it
   * nc -zvw 2 <database_pod_ip> 3306 - `this should also be successful`
7. Create the network policy file, and `k apply -f app-stack-network-policy.yaml`.
8. Perform the `netcat` operations again. This time, #5 operation should be unsuccessful, but #6 should continue to be successful as per the defined network policy. 
