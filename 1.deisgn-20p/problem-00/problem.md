- This practice problem is taken from `https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552`. This problem is more like practicing basic commands.
1. Run the command `k apply -f env.yml`
2. Switch to `ch1p00` namespace for this lab.
3.  List all the namespaces in the cluster
4.  List all the pods in all namespaces
5.  List all the pods in the `kube-system` namespace
6.  List all the services in the `kube-system` namespace
7.  Create a pod using `nginx` image named `pod1` in the `ch1p00` namespace and verify the pod running
8.  Create a pod template yaml file, the pod should use `busybox` image, and have a name `pod2` in the `ch1p00` namespace, you should not create the pod, only the pod template in a file called pod.yml.
9. There is already a pod running named `editme`, update the image of the pod to `busybox:musl`
10. Delete pod1 and wait until it's get deleted.
11. Force delete pod `editme`  but do not wait for it. (Also, same solution is application if a pod is hang in terminating state)
12. Create a pod with name `nginx` and image `nginx:1.17.4` and expose it on port 80
13. Change the Image version to 1.15-alpine for the pod you just created and verify the image version is updated.
14. Change the Image version back to 1.17.1 for the pod you just updated and observe the changes
15. Execute the simple shell on the pod `nginx`
16. Get the IP Address of the pod you just created.
17. Create a pod named `busybox` using image `busybox` and run command ls while creating it and check the logs.
18. Get the log from the most recent crush of the pod nginx .    
19. Create a temporary pod named `tmp` using image `busybox` and check the connection to the `nginx` pod from the `tmp` pod.

