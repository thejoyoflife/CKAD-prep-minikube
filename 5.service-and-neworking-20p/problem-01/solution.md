- setup the environment by running the following commands
```
for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-exttrust-2 ch5p01-animals ch5p01-fruits ch5p01-universe; do k create ns $myns; done
# for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-exttrust-2 ch5p01-animals ch5p01-fruits ch5p01-universe; do k delete ns $myns; done
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
    - k describe netpol netpol1 `always a good practice to check this for netpol resource`
    - k $tmp --labels=tag=withinNS -- wget -O- 10.244.205.229 -T 2`returns 2xx`
    - k $tmp -- wget -O- 10.244.205.229 -T 2 `returns wget: download timed out - same namespace but does not have the correct label`
    - $tmp --labels=tag=withinNS -n ch5p01-universe -- wget -O- 10.244.205.229 -T 2 `returns wget: download timed out - different namespace, having correct label does not matter`
- pod2 with label `tag=subtask2` in the `ch5p01-secured` should only be accessible from pods with label `tag=outsideNS` from any namespace.
    - k apply -f netpol2.yml 
    - k describe netpol netpol2 `always a good practice to check this for netpol resource`
    - k $tmp --labels=tag=outsideNS -- wget -O- 10.244.205.228 -T 2 `returns 2xx`
    - k $tmp -- wget -O- 10.244.205.228 -T 2 `returns wget: download timed out - same namespace but does not have the correct label`
    - k $tmp --labels=tag=outsideNS -n ch5p01-universe -- wget -O- 10.244.205.228 -T 2 `returns 2xx`
    - k $tmp -n ch5p01-universe -- wget -O- 10.244.205.228 -T 2 `returns wget: download timed out - does not have the correct label`
- pod3 with label `tag=subtask3` in the `ch5p01-secured` should only be accessible from pods within the namespace `ch5p01-trusted`. ---------------------->[doc02]
    - k  get ns ch5p01-trusted --show-labels
    - k apply -f netpol3.yml 
    - k describe netpol netpol3 `always a good practice to check this for netpol resource`
    - k $tmp -n ch5p01-trusted -- wget -O- 10.244.205.218 -T 2 `returns 2xx`
    - k $tmp -- wget -O- 10.244.205.218 -T 2 `wget: download timed out , even from the same same namespace , the pods are not allowed`
    - k $tmp -n ch5p01-universe -- wget -O- 10.244.205.218 -T 2 `wget: download timed out , a different namespace than the allowed one`
- pod4 with label `tag=subtask4` in the `ch5p01-secured` should only be accessible from the pods label `tag=allowed` within the namespace `ch5p01-internal` .  ---------------------->[doc03A]
    - get ns ch5p01-internal --show-labels
    - k apply -f netpol4.yml 
    - k describe netpol netpol4 `always a good practice to check this for netpol resource`
    - k $tmp -n ch5p01-internal --labels=tag=allowed -- wget -O- 10.244.205.231 -T 2 `returns 2xx`
    - k $tmp --labels=tag=allowed -- wget -O- 10.244.205.231 -T 2 `returns wget: download timed out because of the right label but wrong namepsace (event from the same one)`
    - k $tmp -n ch5p01-internal -- wget -O- 10.244.205.231 -T 2 `returns  wget: download timed out because of the right namespace but wrong label`
- pod5 with label `tag=subtask5` in the `ch5p01-secured` should only be accessible from the pods with label `tag=insidetrust` within *the same namespace* AND from all pods from namespace `ch5p01-exttrust`.[doc03B]
    - k get ns ch5p01-exttrust --show-labels
    - k describe netpol netpol5 `always a good practice to check this for netpol resource`
    - k $tmp --labels=tag=insidetrust -- wget -O- 10.244.205.235 -T 2 `returns 2xx`
    - k $tmp -n ch5p01-exttrust -- wget -O- 10.244.205.235 -T 2 `returns 2xx, notice any pod regardless of the label from ch5p01-exttrust namespace is allowed`
    - k $tmp -n ch5p01-universe --labels=tag=insidetrust -- wget -O- 10.244.205.235 -T 2 `returns wget: download timed out, though label is correct, it's from the different namespace`
    - **VVI - definitive proof that when using OR(podSelector,namespaceSelector) the podSelector defines rule for it's own namespace(since same label but different namespace could not connect) and the namespaceSelector allows all pods from that namespace(since pod without any label from ch5p01-universe namespace was able to connect )**. For AND(podSelector,namespaceSelector) example, see `subtask4`.
- pod6 with label `tag=subtask6` in the `ch5p01-secured` should only be accessible from pods with label `tag=globaltrust` within *any namespace*  AND from all pods from namespace `ch5p01-exttrust-2`.  
    - k get ns ch5p01-exttrust-2 --show-labels
    - k apply -f netpol6.yml 
    - k describe netpol netpol6 `always a good practice to check this for netpol resource`
    - k $tmp -n ch5p01-exttrust-2 -- wget -O- 10.244.205.245 -T 2 `returns 2xx, see all pods in the namespace ch5p01-exttrust-2 is reachable regardless of label!`
    - k $tmp -- wget -O- 10.244.205.245 -T 2 `returns wget: download timed out, outside ch5p01-exttrust-2 namespace, it does not allow pod without the label tag=globaltrust, not from it's own namespace`
    - k $tmp --labels=tag=globaltrust -- wget -O- 10.244.205.245 -T 2 `returns 2xx since it has the right tag although from the same namespace`
    - k $tmp -n ch5p01-universe --labels=tag=globaltrust -- wget -O- 10.244.205.245 -T 2 `returns 2xx, from an outside namespace since it has the correct label it can reach`
    - k $tmp -n ch5p01-universe -- wget -O- 10.244.205.245 -T 2 `returns  wget: download timed out because it's not from ch5p01-exttrust-2 namespace and it deos not have the correct label.`
- pod7 with label `tag=subtask7` in the `ch5p01-secured` should only be accessible from pods with label `tag: fox` from namespace `ch5p01-animals` AND from pods with label `tag: mango` from namespace `ch5p01-fruits`.
    - k get ns ch5p01-animals --show-labels
    - k get ns ch5p01-fruits --show-labels
    - k apply -f netpol7.yml 
    - k describe netpol netpol7 `always a good practice to check this for netpol resource`
    - k $tmp -n ch5p01-animals --labels=tag=fox -- wget -O- 10.244.205.233  -T 2 `returns 2xx`
    - k $tmp -n ch5p01-animals -- wget -O- 10.244.205.233  -T 2 `returns wget: download timed out, because correct namespace but the label is missing`
    - k $tmp --labels=tag=fox -- wget -O- 10.244.205.233  -T 2 `returns wget: download timed out, because correct label but the namespace is missing`
    - k $tmp -n ch5p01-fruits --labels=tag=mango -- wget -O- 10.244.205.233  -T 2 `returns 2xx`
    - k $tmp -n ch5p01-fruits -- wget -O- 10.244.205.233  -T 2 `returns wget: download timed out, because correct namespace but the label is missing`
    - k $tmp --labels=tag=mango -- wget -O- 10.244.205.233  -T 2 `returns wget: download timed out, because correct label but the namespace is missing`
    - k $tmp -n ch5p01-animals --labels=tag=mango -- wget -O- 10.244.205.233  -T 2 `returns  wget: download timed out, wrong combination of namespace and tag`

- pod8 with label `tag=subtask8` in the `ch5p01-secured` should only be accessible from the pods within the sanme namespace.
- pod9 with label `tag=subtask9` in the `ch5p01-secured` should not be accepting traffic from any pod within the same namespace, but the pod should accept traffic from any pod from any other namespace.
