- Create the test environment by using `k apply -f env.yml` and change to namespace `ch4p04`

1. Create a configuration using the contents of the directory sports and name it `cfgfromfile`
    - Mount it in a pod called pod1 and make all the keys available via environment variable. Use nginx image for the pod.
        - k create cm cfgfromfile --from-file=sports
        - k create cm cfgfromfile --from-file=mycustomename=sports `error: cannot give a key name for a directory path, only applicable for a file path`
        - k get cm cfgfromfile -o yaml
        ```
        apiVersion: v1
        data:
            indoor: chess
            outdoor: cricket
        ```
        - k apply -f pod1.yml
        - k exec pod1 -it -- env
        ```
        indoor=chess
        outdoor=cricket
        ```
    - Mount it in a pod called pod2 and make only 'indoor' key available via environment variable. Use nginx image for the pod.
        - k apply -f pod2.yml
        - k exec pod2 -it -- env
    - Mount it in a pod called pod3 and make all the keys available via file on path `/etc/config`. Use nginx image for the pod.
        - k apply -f pod3.yml 
        - k exec pod3 -it -- ls /etc/config/
    - Mount it in a pod called pod4 and make only 'indoor' key available via file  on path `/etc/config`. Use nginx image for the pod.
        - k apply -f pod4.yml 
        - k exec pod4 -it -- ls /etc/config/


2. Create a configuration using the contents of the file app.properties and name it `cfgfromenvfile`
    - Mount it in a pod called pod5 and make all the keys available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod6 and make only 'version' key available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod7 and make all the keys available via file. Use nginx image for the pod.
    - Mount it in a pod called pod8 and make only 'version' key available via file. Use nginx image for the pod.
    

3. Create a configuration using gadget=phone,model=iphone pro `cfgfromliteral`
    - Mount it in a pod called pod9 and make all the keys available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod10 and make only 'gadget' key available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod11 and make all the keys available via file. Use nginx image for the pod.
    - Mount it in a pod called pod12 and make only 'gadget' key available via file. Use nginx image for the pod.

4. Create a configuration using the contents of the file `app.properties` and name it `cfgfromfilerenamed` and use the key `appprops`.
    - kubectl create configmap game-config-3 --from-file=game-special-key=configure-pod-container/configmap/game.properties