- Create the test environment by using `k apply -f env.yml`

- pod1 with label `tag=subtask1` in the `ch5p01-secured` should only be accessible from pods with label `tag=withinNS` within the same namespace  ---------------------->[doc01]
- pod2 with label `tag=subtask2` in the `ch5p01-secured` should only be accessible from pods with label `tag=outsideNS` from any namespace.
- pod3 with label `tag=subtask3` in the `ch5p01-secured` should only be accessible from pods within the namespace `ch5p01-trusted`. ---------------------->[doc02]
- pod4 with label `tag=subtask4` in the `ch5p01-secured` should only be accessible from the pods label `tag=allowed` within the namespace `ch5p01-internal` .  ---------------------->[doc03A]
- pod5 with label `tag=subtask5` in the `ch5p01-secured` should only be accessible from the pods with label `tag=insidetrust` within *the same namespace* AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod6 with label `tag=subtask6` in the `ch5p01-secured` should only be accessible from pods with label `tag=globaltrust` within *any namespace*  AND from all pods from namespace `ch5p01-exttrust`.  ---------------------->[doc03B?]
- pod7 with label `tag=subtask7` in the `ch5p01-secured` should only be accessible from pods with label `tag: fox` from namespace `ch5p01-animals` AND from pods with label `tag: mango` from namespace `ch5p01-fruits`.
- pod8 with label `tag=subtask8` in the `ch5p01-secured` should only be accessible from the pods within the sanme namespace.

- Practice problem from the documentation (straighaway copy paste)
    - Default deny all ingress traffic
        - select all pods, define type as ingress and keep the allow list empty by not defining it (.spec.Ingress)
        ```
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
        name: default-deny-ingress
        spec:
            podSelector: {}
            policyTypes:
                - Ingress
        ```
    
    - Allow all ingress traffic
        - select all pods, define type as ingress and use wild card any(- {})  in the allow list (.spec.Ingress)
        ```
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
        name: allow-all-ingress
        spec:
            podSelector: {}
            ingress:
            - {}
            policyTypes:
            - Ingress
        ```
    - Default deny all egress traffic
    - Allow all egress traffic
    - Default deny all ingress and all egress traffic 