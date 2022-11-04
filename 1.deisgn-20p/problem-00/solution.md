1. Run the command `k apply -f env.yml`
2. Switch to `ch1p00` namespace for this lab.
    - kn ch1p00
    - kn `check the current namespace`
3.  List all the namespaces in the cluster
    - k get ns
4.  List all the pods in all namespaces
    - k get pods -A
5.  List all the pods in the `kube-system` namespace
    - k get pods -n kube-system
6.  List all the services in the `kube-system` namespace
    - k get svc -n kube-system
7.  Create a pod using `nginx` image named `pod1` in the `ch1p00` namespace and verify the pod running
    - k run pod1 --image=nginx
    - k get pods pod1 
    - k get pods pod1 -o yaml | grep -i 'namespace' `verifies that the pod was created in ch1p00 namespace`
8.  Create a pod template yaml file, the pod should use `busybox` image, and have a name `pod2` in the `ch1p00` namespace, you should not create the pod, only the pod template in a file called pod.yml.
    - k run pod2 --image=busybox -n ch1p00 $do > pod.yml
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod2
  name: pod2
  namespace: ch1p00
spec:
  containers:
  - image: busybox
    name: pod2
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
9. There is already a pod running named `editme`, update the image of the pod to `busybox:musl`
    - k set image pod editme editme=busybox
    - k edit pod editme and manually change the image `alternative solution but not clean, and risky`
    - k describe pods editme | grep -i 'image'
    
10. Delete pod1 and wait until it's get deleted.
    - k delete pod pod1
11. Force delete pod `editme`  but do not wait for it. (Also, same solution is application if a pod is hang in terminating state)
    - k delete pod editme --grace-petiod=0 --force
12. Create a pod with name `nginx` and image `nginx:1.17.4` and expose it on port 80
    - k run nginx --image=nginx:1.17.4 --port=80
13. Change the Image version to 1.15-alpine for the pod you just created and verify the image version is updated.
    - k set image pod nginx nginx=nginx:1.15-alpine
14. Change the Image version back to 1.17.1 for the pod you just updated and observe the changes
    - k set image pod nginx nginx=nginx:1.17.1
    - `k get pods nginx` should show 2 restarts.
15. Execute the simple shell on the pod `nginx`
    - kubectl get pods nginx -o wide
    - k exec nginx -it -- sh
16. Get the IP Address of the pod you just created.
    - kubectl get pods nginx -o wide
    - k describe pod nginx | grep -i 'ip' `a bit clumsy`
17. Create a pod named `busybox` using image `busybox` and run command ls while creating it and check the logs.
    - run busybox --image=busybox --restart=Never -- ls
    - k logs busybox
18. Get the log from the most recent crush of the pod nginx .    
    - k logs nginx -p
19. Create a temporary pod named `tmp` using image `busybox` and check the connection to the `nginx` pod from the `tmp` pod.
    - k run tmp --rm --restart=Never --image=busybox -it -- wget -O- 10.244.205.217 -T 2
