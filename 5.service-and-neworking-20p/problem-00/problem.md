- Create the test environment by using `k apply -f env.yml`
- Switch to ch5p00

1. Create an nginx pod with name `nginx01`, label app=my-nginx and expose the port 80
2. Create the service for `nginx01` pod with the pod selector app: my-nginx
3. Change the type of the service `nginx01` to NodePort
4. Create the temporary busybox pod and hit the service. Verify the service that it should return the nginx page index.html.
