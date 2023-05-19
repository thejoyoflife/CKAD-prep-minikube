- k create ns app-stack
- kn app-stack
- k apply -f app-stack.yaml
- k get pods -l app=todo -o wide
    * Note down the database pod ip
- k apply -f app-stack-network-policy.yaml
- k debug pod/frontend --image nicolaka/netshoot -it
   * nc -zvw 2 <database_pod_ip> 3306 => it should not succeed - will be timed out
- k debug pod/backend --image nicolaka/netshoot -it
   * nc -zvw 2 <database_pod_ip> 3306 => it should  succeed.