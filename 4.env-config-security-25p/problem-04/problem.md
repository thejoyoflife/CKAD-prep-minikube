- Create the test environment by using `k apply -f env.yml` and change to namespace `ch4p04`

1. Create a configuration using the contents of the directory sports and name it `cfgfromfile`
    - k create cm cfgfromfile --from-file=sports
    - k create cm cfgfromfile --from-file=mycustomename=sports `error: cannot give a key name for a directory path, only applicable for a file path`
    - k get cm cfgfromfile -o yaml
    ```
    apiVersion: v1
    data:
        indoor: chess
        outdoor: cricket
    ```
    
    - Mount it in a pod called pod1 and make all the keys available via environment variable. Use nginx image for the pod.
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
    - k create cm cfgfromenvfile --from-file=app.properties
    - k get cm cfgfromenvfile -o yaml
    ```
    apiVersion: v1
    data:
        app.properties: |-
            version=101
            cloud=aws

    ```
    - Mount it in a pod called pod5 and make all the keys available via environment variable. Use nginx image for the pod.
        - k apply -f pod5.yml 
        - It works but not sure how to print it.
    - Mount it in a pod called pod6 and make only 'version' key available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod7 and make all the keys available via file. Use nginx image for the pod.
    - Mount it in a pod called pod8 and make only 'version' key available via file. Use nginx image for the pod.
    
3. Create a configuration using the contents of the file `app.properties` and name it `cfgfromfilerenamed` and use the key `appprops`.
    - VVI when --from-file is used on a file, it will mount the whole file under *one key*, by default that key is the name of the file, but we can rename it using --from-file=KEY_NAME=FILE_PATH (not folder path). We can use --from-file= multiple times. When --from-file points to a directory, each file in that directory is a key and the content of the file is the value of that key. When we mount the *file like key* it mounts as a file, key becomes the file name and the content ( things under |- )becomes the content of the file.
    - k create cm cfgfromfilerenamed --from-file=mynvkeys=app.properties
    - k get cm cfgfromfilerenamed -o yaml
    ```
    apiVersion: v1
    data:
        mynvkeys: |-
            version=101
            cloud=aws
    ```
    - Mount it in a pod called pod9 and make all the keys available via environment variable. Use nginx image for the pod.
        - k apply -f pod9.yml
        - k exec pod9 -it -- sh -c 'echo $mynvkeys'
        ```
        version=101 cloud=aws
        ```
    - Mount it in a pod called pod10 and make only 'version' key available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod11 and make all the keys available via file. Use nginx image for the pod.
    - Mount it in a pod called pod12 and make only 'version' key available via file. Use nginx image for the pod.

4. Create a configuration using gadget=phone,model=iphone pro `cfgfromliteral`
    - Mount it in a pod called pod13 and make all the keys available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod14 and make only 'gadget' key available via environment variable. Use nginx image for the pod.
    - Mount it in a pod called pod15 and make all the keys available via file. Use nginx image for the pod.
    - Mount it in a pod called pod16 and make only 'gadget' key available via file. Use nginx image for the pod.

