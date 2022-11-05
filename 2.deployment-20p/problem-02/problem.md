- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p02
1. List Persistent Volumes in the cluster
2. Create a hostPath PersistentVolume named task-pv-volume with storage 10Gi, access modes ReadWriteOnce, storageClassName manual, and volume at /mnt/data and verify
3. Create a PersistentVolumeClaim of at least 3Gi storage and access mode ReadWriteOnce and verify status is Bound
4. Create an nginx pod with containerPort 80 and with a PersistentVolumeClaim task-pv-claim and has a mouth path "/usr/share/nginx/html"
5. Create a Pod with an image Redis named `redis` and configure a volume that lasts for the lifetime of the Pod and avails `/data` path to the pod. 

