- setup the environment by running the following commands
```
for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-animals ch5p01-fruits ch5p01-universe; do k create ns $myns; done
# for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-animals ch5p01-fruits ch5p01-universe; do k delete ns $myns; done
kn ch5p01-secured


for idx in `seq 1 9`; do k run pod$idx --image=nginx --port=80 --labels=tag=subtask$idx;done;
# for idx in `seq 1 9`; do k delete pod pod$idx ;done;
```
```
NAME   READY   STATUS    RESTARTS   AGE    IP               NODE           NOMINATED NODE   READINESS GATES   LABELS
pod1   1/1     Running   0          133m   10.244.205.229   minikube-m02   <none>           <none>            tag=subtask1
pod2   1/1     Running   0          133m   10.244.205.228   minikube-m02   <none>           <none>            tag=subtask2
pod3   1/1     Running   0          133m   10.244.205.218   minikube-m02   <none>           <none>            tag=subtask3
pod4   1/1     Running   0          133m   10.244.205.231   minikube-m02   <none>           <none>            tag=subtask4
pod5   1/1     Running   0          133m   10.244.205.235   minikube-m02   <none>           <none>            tag=subtask5
pod6   1/1     Running   0          133m   10.244.205.245   minikube-m02   <none>           <none>            tag=subtask6
pod7   1/1     Running   0          133m   10.244.205.233   minikube-m02   <none>           <none>            tag=subtask7
pod8   1/1     Running   0          133m   10.244.205.232   minikube-m02   <none>           <none>            tag=subtask8
pod9   1/1     Running   0          133m   10.244.205.246   minikube-m02   <none>           <none>            tag=subtask9
```
- pod1 with label `tag=subtask1` in the `ch5p01-secured` should only be accessible from pods with label `tag=withinNS` within the same namespace  ---------------------->[doc01]
    - k apply -f netpol1.yml 
    - k $tmp --labels=tag=withinNS -- wget -O- 10.244.205.229 -T 2`returns 2xx`
    - k $tmp -- wget -O- 10.244.205.229 -T 2 `returns wget: download timed out - same namespace but does not have the correct label`
    - $tmp --labels=tag=withinNS -n ch5p01-universe -- wget -O- 10.244.205.229 -T 2 `returns wget: download timed out - different namespace, having correct label does not matter`
- pod2 with label `tag=subtask2` in the `ch5p01-secured` should only be accessible from pods with label `tag=outsideNS` from any namespace.
    - k apply -f netpol2.yml 
    - k $tmp --labels=tag=outsideNS -- wget -O- 10.244.205.228 -T 2 `returns 2xx`
    - k $tmp -- wget -O- 10.244.205.228 -T 2 `returns wget: download timed out - same namespace but does not have the correct label`
    - k $tmp --labels=tag=outsideNS -n ch5p01-universe -- wget -O- 10.244.205.228 -T 2 `returns 2xx`
    - k $tmp -n ch5p01-universe -- wget -O- 10.244.205.228 -T 2 `returns wget: download timed out - does not have the correct label`
- pod3 with label `tag=subtask3` in the `ch5p01-secured` should only be accessible from pods within the namespace `ch5p01-trusted`. ---------------------->[doc02]
    - k  get ns ch5p01-trusted --show-labels
    - k apply -f netpol3.yml 
    - k $tmp -n ch5p01-trusted -- wget -O- 10.244.205.218 -T 2 `returns 2xx`
    - k $tmp -- wget -O- 10.244.205.218 -T 2 `wget: download timed out , even from the same same namespace , the pods are not allowed`
    - k $tmp -n ch5p01-universe -- wget -O- 10.244.205.218 -T 2 `wget: download timed out , a different namespace than the allowed one`
- pod4 with label `tag=subtask4` in the `ch5p01-secured` should only be accessible from the pods label `tag=allowed` within the namespace `ch5p01-internal` .  ---------------------->[doc03A]
- pod5 with label `tag=subtask5` in the `ch5p01-secured` should only be accessible from the pods with label `tag=insidetrust` within *the same namespace* AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod6 with label `tag=subtask6` in the `ch5p01-secured` should only be accessible from pods with label `tag=globaltrust` within *any namespace*  AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod7 with label `tag=subtask7` in the `ch5p01-secured` should only be accessible from pods with label `tag: fox` from namespace `ch5p01-animals` AND from pods with label `tag: mango` from namespace `ch5p01-fruits`.
- pod8 with label `tag=subtask8` in the `ch5p01-secured` should only be accessible from the pods within the sanme namespace.
- pod9 with label `tag=subtask9` in the `ch5p01-secured` should not be accepting traffic from any pod within the same namespace, but the pod should accept traffic from any pod from any other namespace.
