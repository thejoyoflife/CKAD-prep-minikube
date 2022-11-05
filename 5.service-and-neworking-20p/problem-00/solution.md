1. Create an nginx pod with name `nginx01`, label app=my-nginx and expose the port 80
    - k run nginx01 --image=nginx --labels=app=my-nginx --port=80
    - k get pods --show-labels
2. Create the service for `nginx01` pod with the pod selector app: my-nginx
    - k expose pod nginx01

3. Change the type of the service `nginx01` to NodePort
    - k edit service nginx01
    - k get svc `copy the ip - 10.105.137.216`
4. Create the temporary busybox pod and hit the service. Verify the service that it should return the nginx page index.html.
    - tmp --image=busybox
    - wget -O- 10.105.137.216