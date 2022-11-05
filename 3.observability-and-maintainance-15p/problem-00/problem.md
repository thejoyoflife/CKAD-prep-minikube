- Create the test environment by using `k apply -f env.yml`
- Switch to ch3p00

1. Create a pod named `nginx01` with image nginx, containerPort 80 and it should only receive traffic only it checks the endpoint / on port 80.  Create a readiness and liveness probe on port 80, path /, liveness and readiness probes so that it should wait for 20 seconds before it checks liveness and readiness probes and it should check every 25 seconds.
    - k run nginx01 --image=nginx --port=80 $do > nginx01.yml
    - search readinessprobe in the official doc.
    - k apply -f nginx01.yml
    - if there is a readiness or liveness probe failed it will appear in the Events section of the command `k describe pods nginx01` 
10.  Create the pod with the yaml `not-running.yml`. The pod is not in the running state. Debug it.
    -  k get pods not-running 
    ```
    NAME          READY   STATUS             RESTARTS   AGE
    not-running   0/1     ImagePullBackOff   0          20s
    ```
    - k describe pod not-running | grep 'Events:' -A 100
    ```
    Events:
    Type     Reason     Age                From               Message
    ----     ------     ----               ----               -------
    Normal   Scheduled  66s                default-scheduler  Successfully assigned ch3p00/not-running to minikube-m02
    Normal   Pulling    17s (x3 over 65s)  kubelet            Pulling image "ngin"
    Warning  Failed     12s (x3 over 60s)  kubelet            Failed to pull image "ngin": rpc error: code = Unknown desc = Error response from daemon: pull access denied for ngin, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
    Warning  Failed     12s (x3 over 60s)  kubelet            Error: ErrImagePull
    Normal   BackOff    1s (x3 over 60s)   kubelet            Back-off pulling image 
    ```
    - k set image pod not-running not-running=nginx
    - k get pods not-running 
    ```
    NAME          READY   STATUS    RESTARTS   AGE
    not-running   1/1     Running   0          2m46s
    ```
    
11. Apply the yaml `problem-pod.yaml` which creates 4 namespaces and 4 pods. One of the pod in one of the namespaces are not in the running state. Debug and fix it.
    - bash-3.2$ k get pods -A
    ```
    NAMESPACE       NAME                                        READY   STATUS             RESTARTS       AGE
    ch3p00          nginx01                                     1/1     Running            0              9m42s
    ch3p00          not-running                                 1/1     Running            0              6m42s
    ingress-nginx   ingress-nginx-admission-create-pvtjb        0/1     Completed          0              2d
    ingress-nginx   ingress-nginx-admission-patch-9c4tf         0/1     Completed          0              2d
    ingress-nginx   ingress-nginx-controller-755dfbfc65-6jqlt   1/1     Running            9 (27h ago)    2d
    kube-system     calico-kube-controllers-c44b4545-m8qrw      1/1     Running            9 (27h ago)    2d
    kube-system     calico-node-4874s                           1/1     Running            0              2d
    kube-system     calico-node-jrhv5                           1/1     Running            0              2d
    kube-system     coredns-6d4b75cb6d-wzsdq                    1/1     Running            0              2d
    kube-system     etcd-minikube                               1/1     Running            0              2d
    kube-system     kube-apiserver-minikube                     1/1     Running            0              2d
    kube-system     kube-controller-manager-minikube            1/1     Running            0              2d
    kube-system     kube-proxy-lpdmx                            1/1     Running            0              2d
    kube-system     kube-proxy-pwpx4                            1/1     Running            0              2d
    kube-system     kube-scheduler-minikube                     1/1     Running            0              2d
    kube-system     metrics-server-8595bd7d4c-xn9wq             1/1     Running            8 (27h ago)    39h
    kube-system     storage-provisioner                         1/1     Running            13 (26h ago)   2d
    namespace1      pod1                                        1/1     Running            0              86s
    namespace2      pod2                                        0/1     ImagePullBackOff   0              86s
    namespace3      pod3                                        1/1     Running            0              86s
    namespace4      pod4                                        1/1     Running            0              86s
    ```
    - pod `pod2` in namespace `namespace2` is in ErrImagePull status.
    - k describe pod pod2 -n namespace2
    - k describe pod pod2 -n namespace2 | grep 'Events:' -A100
    ```
    Events:
    Type     Reason     Age                  From               Message
    ----     ------     ----                 ----               -------
    Normal   Scheduled  2m37s                default-scheduler  Successfully assigned namespace2/pod2 to minikube-m02
    Normal   Pulling    51s (x4 over 2m35s)  kubelet            Pulling image "ngnx"
    Warning  Failed     46s (x4 over 2m24s)  kubelet            Failed to pull image "ngnx": rpc error: code = Unknown desc = Error response from daemon: pull access denied for ngnx, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
    Warning  Failed     46s (x4 over 2m24s)  kubelet            Error: ErrImagePull
    Warning  Failed     32s (x6 over 2m24s)  kubelet            Error: ImagePullBackOff
    Normal   BackOff    21s (x7 over 2m24s)  kubelet            Back-off pulling image "ngnx"
    ```
    - k set image pod pod2 pod2=nginx -n namespace2
    ```
    NAMESPACE       NAME                                        READY   STATUS      RESTARTS       AGE
    ch3p00          nginx01                                     1/1     Running     0              12m
    ch3p00          not-running                                 1/1     Running     0              9m44s
    ingress-nginx   ingress-nginx-admission-create-pvtjb        0/1     Completed   0              2d
    ingress-nginx   ingress-nginx-admission-patch-9c4tf         0/1     Completed   0              2d
    ingress-nginx   ingress-nginx-controller-755dfbfc65-6jqlt   1/1     Running     9 (27h ago)    2d
    kube-system     calico-kube-controllers-c44b4545-m8qrw      1/1     Running     9 (27h ago)    2d
    kube-system     calico-node-4874s                           1/1     Running     0              2d
    kube-system     calico-node-jrhv5                           1/1     Running     0              2d
    kube-system     coredns-6d4b75cb6d-wzsdq                    1/1     Running     0              2d
    kube-system     etcd-minikube                               1/1     Running     0              2d
    kube-system     kube-apiserver-minikube                     1/1     Running     0              2d
    kube-system     kube-controller-manager-minikube            1/1     Running     0              2d
    kube-system     kube-proxy-lpdmx                            1/1     Running     0              2d
    kube-system     kube-proxy-pwpx4                            1/1     Running     0              2d
    kube-system     kube-scheduler-minikube                     1/1     Running     0              2d
    kube-system     metrics-server-8595bd7d4c-xn9wq             1/1     Running     8 (27h ago)    39h
    kube-system     storage-provisioner                         1/1     Running     13 (26h ago)   2d
    namespace1      pod1                                        1/1     Running     0              4m28s
    namespace2      pod2                                        1/1     Running     0              4m28s
    namespace3      pod3                                        1/1     Running     0              4m28s
    namespace4      pod4                                        1/1     Running     0              4m28s
    ```
    - To clean up run `k delete ns ch3p00 namespace{1..4}`