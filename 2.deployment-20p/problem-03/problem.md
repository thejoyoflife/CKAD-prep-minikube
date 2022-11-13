- Create a stateful set and verify each of the pods has it's own dns
- k create svc clusterip hls `k create svc clusterip hls --clusterip="None"`
- get the pvcs created
```
bash-3.2$ k get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
www-mysfset-0   Bound    pvc-c2444636-97b0-4137-9dd7-cd5b3003ade5   4Mi        RWO            standard       18m
www-mysfset-1   Bound    pvc-7b0f4f4f-2b6e-4317-8862-ef59ab371788   4Mi        RWO            standard       18m
www-mysfset-2   Bound    pvc-21b89d7d-51cc-4140-9279-cb18a955ad55   4Mi        RWO            standard       18m
```
- get the pv created
```
k get pv -o wide
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE   VOLUMEMODE
pvc-21b89d7d-51cc-4140-9279-cb18a955ad55   4Mi        RWO            Delete           Bound    ch4p05/www-mysfset-2   standard                18m   Filesystem
pvc-7b0f4f4f-2b6e-4317-8862-ef59ab371788   4Mi        RWO            Delete           Bound    ch4p05/www-mysfset-1   standard                19m   Filesystem
pvc-c2444636-97b0-4137-9dd7-cd5b3003ade5   4Mi        RWO            Delete           Bound    ch4p05/www-mysfset-0   standard                19m   Filesystem
```
- k $rc mysfset-1.hls.ch4p05.svc.cluster.local `POD_NAME.SVC_NAME.NAMESPACE.svc.cluster.local`
- k $rc mysfset-0.hls.ch4p05.svc.cluster.local
- k $rc mysfset-2.hls.ch4p05.svc.cluster.local
- k delete -f sfset.yml 
- cp sfset.yml sfset2.yml  and delete the initcontainer part, now run it again and then we will see that the pv and pvcs and data are all preserved for www-mysfset-0,www-mysfset-1,www-mysfset-2.
- k apply -f sfset2.yml 