- `k run hello-world --image bmuschko/nodejs-hello-world:1.0.0 --restart Never --image-pull-policy IfNotPresent --port 3000 $do | k set resources -f - --requests=cpu=100m,memory=500Mi,ephemeral-storage=1Gi --limits=memory=500Mi,ephemeral-storage=2Gi --local -o yaml > pod.yaml`
- Change the `pod.yaml` file to include an `emptyDir` volume and mount it in the container under `/var/log` path.
- `k apply -f pod.yaml`
- `k get pod hello-world -o jsonpath='{.spec.nodeName}'` => returns node name where the pod is running.