1. Run the command `k apply -f env.yml`
2. Switch to `ch1p03` namespace for this lab.
3. Create a pod with labels env=staging and tier=web. Use image nginx and name it pod-ex1. List env and tier as column for all the pods available.
    - k run pod-ex1 --image=nginx --labels=env=staging,tier=web
    - 
4. There is a pod called podtolabel and add a label to the pod called team: finance, annotate the pod with costcenter: abc123
    - k label pod podtolabel team=finance
    - k annotate pod podtolabel costcenter=abc123
    - k annotate pod podtolabel --list
    - k get pod podtolabel --show-labels
5. Find all the pods with label az and add a new label called cloud: aws
    - k get pods -l=az --show-labels `you should see two results`
    ```
    NAME    READY   STATUS    RESTARTS   AGE   LABELS
    pod02   1/1     Running   0          87s   az=ap-southeast-01,instance=m4large,storage=io3
    pod03   1/1     Running   0          87s   az=ap-southeast-01,instance=t3small,storage=gp2
    ```
    - k label pod -l=az cloud=aws
    ```
    pod/pod02 labeled
    pod/pod03 labeled
    ```
    - k get pods -l=az -L cloud,az `verify the result`
    ```
    NAME    READY   STATUS    RESTARTS   AGE     CLOUD   AZ
    pod02   1/1     Running   0          4m39s   aws     ap-southeast-01
    pod03   1/1     Running   0          4m39s   aws     ap-southeast-01
    ```
6. Find all the pods with label env=prod and annotate them with type: production
    - k get pod -l env=prod -L env
    ```
    NAME      READY   STATUS    RESTARTS   AGE    ENV
    nginx01   1/1     Running   0          118s   prod
    nginx02   1/1     Running   0          118s   prod
    ```
    - k annotate pod -l env=prod type=production
    ```
    pod/nginx01 annotated
    pod/nginx02 annotated
    ```
7. Find all the pods with label instance=m4large and update them with label instance=c4Large
    -  k get pod -l instance=m4large -L instance
    ```
    NAME    READY   STATUS    RESTARTS   AGE   INSTANCE
    pod01   1/1     Running   0          13m   m4large
    pod02   1/1     Running   0          13m   m4large
    ```
    - k label pods -l instance=m4large instance=c4Large --overwrite
    ```
    pod/pod01 labeled
    pod/pod02 labeled
    ```
    - k get pod -l instance=c4Large -L instance
    ```
    NAME    READY   STATUS    RESTARTS   AGE   INSTANCE
    pod01   1/1     Running   0          16m   c4Large
    pod02   1/1     Running   0          16m   c4Large
    ```
8. Find all the pods which has a label instance and storage=gp2
    - k get pods -l=instance,storage=gp2
    - k get pods -l=instance,storage=gp2 -L instance,storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   INSTANCE   STORAGE
    pod01   1/1     Running   0          17m   c4Large    gp2
    pod03   1/1     Running   0          17m   t3small    gp2
    ```
9. Find all the pods which has a label storage=gp2 or io3.
    - k get pods -l='storage in (gp2,io3)' -L storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   STORAGE
    pod01   1/1     Running   0          18m   gp2
    pod02   1/1     Running   0          18m   io3
    pod03   1/1     Running   0          18m   gp2
    pod04   1/1     Running   0          18m   io3
    ```
10. Find all the pods which has a label instance=t3small and storage=gp2
    - k get pods -l=instance=t3small,storage=gp2
    - k get pods -l=instance=t3small,storage=gp2 -L instance,storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   INSTANCE   STORAGE
    pod03   1/1     Running   0          19m   t3small    gp2
    ```
11. Find all the pods which has a label az=ap-southeast-01, has a label called instance and has label storage=gp2 or io3 and az=ap-southeast-01
    - k get pods -l=az=ap-southeast-01,instance,'storage in (gp2,io3)'
    - k get pods -l=az=ap-southeast-01,instance,'storage in (gp2,io3)' -L az,instance,storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   AZ                INSTANCE   STORAGE
    pod02   1/1     Running   0          21m   ap-southeast-01   c4Large    io3
    pod03   1/1     Running   0          21m   ap-southeast-01   t3small    gp2
    ```
12. Find all the pods which has a label instance= c4Large,m4large or t3small AND storage=gp2 or io3
    - k get pods -l='instance in (c4Large,m4large,t3small)','storage in (gp2,io3)'
    - k get pods -l='instance in (c4Large,m4large,t3small)','storage in (gp2,io3)' -L instance,storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   INSTANCE   STORAGE
    pod01   1/1     Running   0          23m   c4Large    gp2
    pod02   1/1     Running   0          23m   c4Large    io3
    pod03   1/1     Running   0          23m   t3small    gp2
    pod04   1/1     Running   0          23m   t3small    io3
    ```
13. Delete instance label from all pods
    - k label pod -l=instance instance-
    ```
    pod/pod01 unlabeled
    pod/pod02 unlabeled
    pod/pod03 unlabeled
    pod/pod04 unlabeled
    ```
    - k get pods -L instance `notice that the instance column is all empty`
    ```
    NAME         READY   STATUS    RESTARTS   AGE   INSTANCE
    nginx01      1/1     Running   0          13m   
    nginx02      1/1     Running   0          13m   
    nginx03      1/1     Running   0          13m   
    nginx04      1/1     Running   0          13m   
    nginx05      1/1     Running   0          13m   
    nginx06      1/1     Running   0          13m   
    pod-ex1      1/1     Running   0          32m   
    pod01        1/1     Running   0          24m   
    pod02        1/1     Running   0          24m   
    pod03        1/1     Running   0          24m   
    pod04        1/1     Running   0          24m   
    podtolabel   1/1     Running   0          29m 
    ```

14. Remove storage label from the pods that has label cloud
    - k label pod -l=cloud storage-
    - k get pod -l=cloud -L storage
    ```
    NAME    READY   STATUS    RESTARTS   AGE   STORAGE
    pod02   1/1     Running   0          28m   
    pod03   1/1     Running   0          28m  
    ```
15. Read all the annotations of a pod anmed `podtolabel`
    - k annotate pod podtolabel --list
16. Annotate all the pods has label storage and annotate them with costly: true
    - k annotate pod -l=storage  costly=true
    ```
    pod/pod01 annotated
    pod/pod04 annotated
    ```
17. Delete `costcenter` annotation from the pod `podtolabel`
    - k annotate pod podtolabel costcenter-
    ```
    pod/podtolabel annotated
    ```
18. change the annotation of the pods has label `storage` and update annotation `costly: true` to `costly: very-much`
    - k annotate pod -l=storage costly=very-much --overwrite
    ```
    pod/pod01 annotated
    pod/pod04 annotated
    ```