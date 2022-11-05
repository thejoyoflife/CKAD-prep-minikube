- Create the test environment by using `k apply -f env.yml`
- Switch to ch4p00
1. List all the configmaps in the cluster
    - k get cm `each namespace has a kube-root-ca.crt`
2. Create a configmap called myconfigmap with literal value appname=myapp
    - k create cm myconfigmap --from-literal=appname=myapp
    - k get cm myconfigmap -o yaml
3. Verify the configmap we just created has this data
    - k get cm myconfigmap -o yaml
4. Delete the configmap myconfigmap we just created
    - k delete cm myconfigmap

6. Create a configmap named keyvalcfgmap and read data from the file config.txt and verify that configmap is created correctly
    - k create cm keyvalcfgmap --from-env-file=config.txt
    - k get cm keyvalcfgmap -o yaml
7. Create an nginx pod named `nginx01` and load environment values from the above configmap keyvalcfgmap and exec into the pod and verify the environment variables and delete the pod
    - k run nginx01 --image=nginx $do > nginx01.yml
    - vi nginx01.yml `search the official doc by envFrom and take the hint`
    - k apply -f nginx01.yml
    - k exec nginx01 -it -- env | grep 'key'
    ```
    key1=value1
    key2=value2
    ```

10. Create a configmap called cfgvolume with values var1=val1, var2=val2 and create an nginx pod with volume nginx-volume which reads data from this configmap cfgvolume and put it on the path /etc/cfg
    - k create cm cfgvolume --from-literal=var1=val1 --from-literal=var2=val2
    - k exec nginx02 -it -- ls /etc/cfg
    - k exec nginx02 -it -- cat /etc/cfg/var1 `k exec nginx02 -it -- cat /etc/cfg/var1;echo; - to see the value with a new line`
    - k exec nginx02 -it -- cat /etc/cfg/var2 `k exec nginx02 -it -- cat /etc/cfg/var2;echo;  - to see the value with a new line`

11. Create a pod called secbusybox with the image busybox which executes command sleep 3600 and makes sure any Containers in the Pod, all processes run with user ID 1000 and with group id 2000 and verify.
    - k run secbusybox --image=busybox $do -- sleep 3600 > secbusybox.yml
    - search the doc with securitycontext and take the hint.
    - k apply -f secbusybox.yml 
    - k exec secbusybox -it -- top -bn1 `you should see USER 1000`
12. Copy the previous secbusybox.yaml file and overwrite the pod level security context in the container level security context, it should run as user 1111 and group 2222. Verify that the container level security group settings are picked over the pod level settings.
    - cp secbusybox.yml secbusybox2.yml
    - do the necessary changes.
    - k apply -f secbusybox2.yml 
    - k exec secbusybox2 -it -- top -bn1 `you should see USER 1111`
13. Create pod with an nginx image named `nginx03` and configure the pod with capabilities NET_ADMIN and SYS_TIME verify the capabilities
    - k run nginx03 --image=nginx $do > nginx03.yml
    - vi nginx03.yml `search the doc by security context and look for capabilities`
    -  k exec nginx03 -it -- cat /proc/1/status | grep 'CapPrm' ` you should see CapPrm: 00000000aa0435fb`
    -  k exec nginx03 -it -- cat /proc/1/status | grep 'CapEff' `you should see CapEff: 00000000aa0435fb`
    - Please take note, the capabilities needs to be added at the container level, not the pod level.
14. Create a Pod nginx named `nginx04` and specify a memory request and a memory limit of 100Mi and 200Mi respectively, CPU request and a CPU limit of 0.5 and 1 respectively.
    - k run nginx04 --image nginx $do > nginx04.yml
    - search the doc with `resource request limit` and take the hint.
    - vi nginx04.yml 
    - k apply -f nginx04.yml 
    - k describe pod nginx04 `check the requests and limits`
18. Create a secret mysecret with values user=myuser and password=mypassword
    - k create secret generic mysecret --from-literal=user=myuser --from-literal=password=mypassword
19. List the secrets in all namespaces
    - k get secret 
20. Output the yaml of the secret created above
    - k get secret mysecret -o yaml
21. Create an nginx pod named `nginx05` which reads user from the mysecret and bind it with USERNAME environment variable
    - k run nginx05 --image=nginx $do > nginx05.yml
    - search the official document with secret and search with `env:` - notice it's not `env`, it's `env:` 
    - k apply -f nginx05.yml
    - k exec nginx05 -it -- env | grep USERNAME
22. Create an nginx pod named `nginx06` which loads the secret from `mysecret` and expose it in the path /etc/secrets
    - k run nginx06 --image=nginx $do > nginx06.yml
    - search the official document with secret and search with `volumeMounts`
    - k exec nginx06 -it -- ls /etc/secrets
    - k exec nginx06 -it -- cat /etc/secrets/user;echo;
    - k exec nginx06 -it -- cat /etc/secrets/password;echo;