- `k apply -f setup.yaml`
- Inspect the objects created from above: `k get all -o wide -n <ns_name>`. This should reveal there is a mismatch between the deployment selector (`app=web-app`) and the corresponding service's selector (`run=myapp`).
- `kn <ns_name>` - to switch to the namespace to troubleshoot faster.
- `k get ep` - this shows that there is no endpoint registered for the `web-app` service.
- `k edit svc web-app` - change the service's selector. This should register both the pod endpoints registered under the service.
- Now, test the service. `k run tmp --image busybox --rm -it -- wget -qO- web-app -T 2` => this gets timed out!!! The problem is not fixed yet.
- Check the ports - both the deployment's port and the service's target port. 
    * `k describe deploy web-app | grep -i Port` , `k get svc web-app -o yaml | grep -i targetport` => this shows that there is a mismatch between the ports; deployment is on port `3000`, but the service's `targetPort` is on `3001`. Edit the service as mentioned above and fix the port. Now the testing should succeefully return "Hello World" response.
