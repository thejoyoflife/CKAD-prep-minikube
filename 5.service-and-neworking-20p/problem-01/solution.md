- setup the environment by running the following commands
```
for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-animals ch5p01-fruits ch5p01-universe; do k create ns $myns; done
# for myns in ch5p01-secured ch5p01-trusted ch5p01-internal ch5p01-exttrust ch5p01-animals ch5p01-fruits ch5p01-universe; do k delete ns $myns; done
kn ch5p01-secured


for idx in `seq 1 9`; do k run pod$idx --image=nginx --port=80 --labels=tag=subtask$idx;done;
# for idx in `seq 1 9`; do k delete pod pod$idx ;done;
```
- pod1 with label `tag=subtask1` in the `ch5p01-secured` should only be accessible from pods with label `tag=withinNS` within the same namespace  ---------------------->[doc01]
- pod2 with label `tag=subtask2` in the `ch5p01-secured` should only be accessible from pods with label `tag=outsideNS` from any namespace.
- pod3 with label `tag=subtask3` in the `ch5p01-secured` should only be accessible from pods within the namespace `ch5p01-trusted`. ---------------------->[doc02]
- pod4 with label `tag=subtask4` in the `ch5p01-secured` should only be accessible from the pods label `tag=allowed` within the namespace `ch5p01-internal` .  ---------------------->[doc03A]
- pod5 with label `tag=subtask5` in the `ch5p01-secured` should only be accessible from the pods with label `tag=insidetrust` within *the same namespace* AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod6 with label `tag=subtask6` in the `ch5p01-secured` should only be accessible from pods with label `tag=globaltrust` within *any namespace*  AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod7 with label `tag=subtask7` in the `ch5p01-secured` should only be accessible from pods with label `tag: fox` from namespace `ch5p01-animals` AND from pods with label `tag: mango` from namespace `ch5p01-fruits`.
- pod8 with label `tag=subtask8` in the `ch5p01-secured` should only be accessible from the pods within the sanme namespace.
- pod9 with label `tag=subtask9` in the `ch5p01-secured` should not be accepting traffic from any pod within the same namespace, but the pod should accept traffic from any pod from any other namespace.
