- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p02

1. List Persistent Volumes in the cluster
    - k get pv
2. Create a hostPath PersistentVolume named task-pv-volume with storage 10Gi, access modes ReadWriteOnce, storageClassName manual, and volume at /mnt/data and verify
    - vi task-pv-volume.yml `copy paste the basic template from the documnetation and then work on it`
    - k apply -f task-pv-volume.yml
    - k get pv
    ```
    NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
    task-pv-volume   10Gi       RWO            Retain           Available           manual                  14s
    ```
3. Create a PersistentVolumeClaim of at least 3Gi storage and access mode ReadWriteOnce and verify status is Bound
    - vi task-pv-claim.yml `copy paste the basic template from the documnetation and then work on it`
    - apply -f task-pv-claim.yml 
    - k get pvc `Make sure the status in bound`
    ```
    NAME            STATUS   VOLUME           CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    task-pv-claim   Bound    task-pv-volume   10Gi       RWO            manual         23s
    ```
4. Create an nginx pod with containerPort 80 and with a PersistentVolumeClaim task-pv-claim and has a mouth path "/usr/share/nginx/html". Delete the pod in the end.
    - k run nginx --image=nginx $do > nginx.yml
    - vi nginx.yml `add the additional properties by taking help from the documentation`
    - k apply -f nginx.yml 
    - k delete -f nginx.yml 
5. Create a Pod with an image Redis named `redis` and configure a volume that lasts for the lifetime of the Pod and avails `/data` path to the pod. 
    - k run redis --image=redis $do > redis.yml
    - vi nginx.yml `add the additional properties by taking help from the documentation`
    - k apply -f redis.yml 

